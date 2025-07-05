const { Server } = require('socket.io')

class WebSocketServer {
  constructor(server) {
    this.io = new Server(server, {
      connectionStateRecovery: {},
      cors: { origin: '*' },
    })
    this.asesores = new Map() // socketId -> { userId, socket }
    this.empresasPendientes = [] // [{ userId, socket }]
    this.empresasAsignadas = new Map() // asesorUserId -> [{ empresaId, room }]
  }

  // Utilidad para evitar duplicados en empresasAsignadas
  addEmpresaAsignada(asesorId, empresaId, room, nombreEmpresa) {
    if (!this.empresasAsignadas.has(asesorId)) this.empresasAsignadas.set(asesorId, [])
    const arr = this.empresasAsignadas.get(asesorId)
    if (!arr.some(e => e.empresaId === empresaId && e.room === room)) {
      arr.push({ empresaId, room, nombreEmpresa })
    }
  }


  init() {
    this.io.on('connection', (socket) => {
      console.log(`[WS] Nueva conexión: ${socket.id}`)

      socket.on('join', ({ userId, role, nombreEmpresa }) => {
        if (!userId || !role) {
          console.warn(`[WS] join inválido: userId o role faltante`)
          socket.emit('error', { msg: 'Faltan datos para la conexión.' })
          return
        }

        // Guarda el userId en el socket para identificarlo en disconnect
        socket.userId = userId

        if (role === 'Asesor') {
          this.asesores.set(socket.id, { userId, socket })
          console.log(`[WS] Asesor registrado: userId=${userId}, socketId=${socket.id}`)

          // Enviar todas las empresas asignadas a este asesor
          const asignadas = this.empresasAsignadas.get(userId) || []
          if (asignadas.length > 0) {
            socket.emit('empresas-asignadas', asignadas)
            for (const { room } of asignadas) {
              socket.join(room)
            }

            console.log(`[WS] Enviando empresas asignadas a asesor ${userId}:`, asignadas)
          } else {
            socket.emit('info', { msg: 'No tienes empresas asignadas actualmente.' })
          }

          // Asignar TODAS las empresas pendientes (si hay)
          while (this.empresasPendientes.length > 0) {
            const empresaPendiente = this.empresasPendientes.shift()
            const room = `chat_${empresaPendiente.userId}_${userId}`
            empresaPendiente.socket.join(room)
            socket.join(room)
            empresaPendiente.socket.emit('asesor-asignado', { asesorId: userId, room, msg: '¡Te hemos asignado un agente de soporte!' })
            empresaPendiente.socket.emit('agent-status', true)
            // Aquí agrega nombreEmpresa:
            socket.emit('empresa-asignada', {
              empresaId: empresaPendiente.userId,
              nombreEmpresa: empresaPendiente.nombreEmpresa,
              room,
              msg: 'Se te ha asignado una nueva empresa.'
            })
            this.addEmpresaAsignada(userId, empresaPendiente.userId, room, empresaPendiente.nombreEmpresa)
            console.log(`[WS] Empresa pendiente asignada: empresaId=${empresaPendiente.userId}, asesorId=${userId}, room=${room}`)
          }
        }

        if (['Usuario', 'Empresa'].includes(role)) {
          const asesorEntry = Array.from(this.asesores.values()).find(a => !!a.socket?.connected)
          if (asesorEntry) {
            const room = `chat_${userId}_${asesorEntry.userId}`
            socket.join(room)
            asesorEntry.socket.join(room)
            socket.emit('asesor-asignado', { asesorId: asesorEntry.userId, room, msg: '¡Te hemos asignado un agente de soporte!' })
            socket.emit('agent-status', true)
            asesorEntry.socket.emit('empresa-asignada', { empresaId: userId, nombreEmpresa, room, msg: 'Se te ha asignado una nueva empresa.' })
            this.io.to(room).emit('empresa-status', { empresaId: userId, online: true })
            this.addEmpresaAsignada(asesorEntry.userId, userId, room, nombreEmpresa)
            console.log(`[WS] Empresa asignada: empresaId=${userId}, asesorId=${asesorEntry.userId}, room=${room}`)
          } else {
            this.empresasPendientes.push({ userId, socket, nombreEmpresa })
            socket.emit('agent-status', false)
            socket.emit('sin-asesor', { msg: 'No hay agentes de soporte disponibles en este momento. Por favor, espera a que uno se conecte.' })
            console.log(`[WS] Empresa en espera: empresaId=${userId}, socketId=${socket.id}`)
          }
        }
      })

      // Handler para mensajes de chat
      socket.on('message', ({ room, message, fromUserId }) => {
        const [empresaId, asesorId] = room.replace("chat_", "").split("_")

        // Validar que el socket esté unido al room (por seguridad)
        if (!socket.rooms.has(room)) {
          socket.join(room)
          console.warn(`[WS] El socket ${socket.id} no estaba en el room ${room}, fue agregado.`)
        }

        // Emitir el mensaje a todos los sockets en ese room, incluyendo al remitente
        this.io.to(room).emit('message', { from: fromUserId, message, room })
        console.log(`[WS] Mensaje reenviado a room=${room} de userId=${fromUserId}: ${message}`)

        // Marcar como "empresa en línea" si aplica
        this.io.to(room).emit('empresa-status', { empresaId, online: true })
      })

      socket.on('finalizar-chat', ({ empresaId, room }) => {
        console.log(`[WS] Chat finalizado por asesor para empresaId=${empresaId} en room=${room}`);

        // Eliminar empresa del mapa de empresasAsignadas
        for (const [asesorId, empresas] of this.empresasAsignadas.entries()) {
          const index = empresas.findIndex(e => e.empresaId === empresaId && e.room === room);
          if (index !== -1) {
            empresas.splice(index, 1);
            console.log(`[WS] Empresa eliminada de asignación: asesorId=${asesorId}, empresaId=${empresaId}`);
          }
        }

        // Notificar al cliente que el asesor finalizó el chat
        this.io.to(room).emit('agent-status', false);
        this.io.to(room).emit('system-message', {
          message: 'El asesor finalizó el chat.',
          from: 'system',
          type: 'chat-ended'
        });

        // Sacar a todos del room (opcional)
        this.io.socketsLeave(room);
      });



      socket.on('disconnect', () => {
        if (this.asesores.has(socket.id)) {
          const { userId } = this.asesores.get(socket.id)
          // Notificar a todas las empresas asignadas a este asesor
          const asignadas = this.empresasAsignadas.get(userId) || []
          // Evita duplicados de rooms
          const roomsNotificados = new Set()
          asignadas.forEach(({ empresaId, room }) => {
            if (!roomsNotificados.has(room)) {
              this.io.to(room).emit('agent-status', false)
              this.io.to(room).emit('system-message', {
                message: 'El asesor se ha desconectado.',
                from: 'system',
                type: 'agent-disconnect'
              })
              roomsNotificados.add(room)
            }
          })
          this.asesores.delete(socket.id)
          console.log(`[WS] Asesor desconectado: socketId=${socket.id}`)
        } else {
          // Empresa desconectada: notificar al asesor correspondiente
          const empresaId = socket.userId
          if (empresaId) {
            for (const [asesorId, empresas] of this.empresasAsignadas.entries()) {
              const index = empresas.findIndex(e => e.empresaId === empresaId)
              if (index !== -1) {
                const { room } = empresas[index]
                this.io.to(room).emit('empresa-status', { empresaId, online: false })
                this.io.to(room).emit('system-message', {
                  message: 'El usuario se ha desconectado.',
                  from: 'system',
                  type: 'user-disconnect'
                })
                empresas.splice(index, 1) // ← elimina la empresa asignada
                console.log(`[WS] Empresa eliminada de empresasAsignadas: empresaId=${empresaId}`)
              }
            }
            console.log(`[WS] Empresa desconectada: empresaId=${empresaId}, socketId=${socket.id}`)
          } else {
            console.log(`[WS] Cliente desconectado: socketId=${socket.id}`)
          }
        }
      })
    })
  }
}

module.exports = WebSocketServer