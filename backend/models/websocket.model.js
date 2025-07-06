const { Server } = require('socket.io')

class WebSocketServer {
  constructor(server) {
    this.io = new Server(server, {
      connectionStateRecovery: {},
      cors: { origin: '*' },
    })
    this.asesores = new Map() // socketId -> { userId, socket }
    this.empresasPendientes = [] // [{ userId, socket, nombreEmpresa }]
    this.empresasAsignadas = new Map() // asesorUserId -> [{ empresaId, room, nombreEmpresa }]
  }

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

        socket.userId = userId
        socket.nombreEmpresa = nombreEmpresa || 'Empresa'

        console.log(`[DEBUG] Usuario unido: id=${userId}, role=${role}`)

        if (role === 'Asesor') {
          this.asesores.set(socket.id, { userId, socket })
          console.log(`[WS] Asesor registrado: userId=${userId}, socketId=${socket.id}`)
          console.log(`[DEBUG] Total asesores conectados: ${this.asesores.size}`)

          const asignadas = this.empresasAsignadas.get(userId) || []
          if (asignadas.length > 0) {
            socket.emit('empresas-asignadas', asignadas)
            for (const { room } of asignadas) socket.join(room)
            console.log(`[WS] Enviando empresas asignadas a asesor ${userId}:`, asignadas)
          } else {
            socket.emit('info', { msg: 'No tienes empresas asignadas actualmente.' })
          }

          while (this.empresasPendientes.length > 0) {
            const empresaPendiente = this.empresasPendientes.shift()

            if (!empresaPendiente.socket?.connected) {
              console.log(`[WS] Empresa ${empresaPendiente.userId} ya no está conectada. Se descarta de la cola.`)
              continue
            }

            const room = `chat_${empresaPendiente.userId}_${userId}`
            empresaPendiente.socket.join(room)
            socket.join(room)

            empresaPendiente.socket.emit('asesor-asignado', {
              asesorId: userId,
              room,
              msg: '¡Te hemos asignado un agente de soporte!'
            })

            empresaPendiente.socket.emit('agent-status', true)

            socket.emit('empresa-asignada', {
              empresaId: empresaPendiente.userId,
              nombreEmpresa: empresaPendiente.nombreEmpresa,
              room,
              msg: 'Se te ha asignado una nueva empresa.'
            })

            this.io.to(room).emit('empresa-status', {
              empresaId: empresaPendiente.userId,
              online: true
            })

            this.addEmpresaAsignada(userId, empresaPendiente.userId, room, empresaPendiente.nombreEmpresa)

            console.log(`[WS] Empresa pendiente asignada: empresaId=${empresaPendiente.userId}, asesorId=${userId}, room=${room}`)
          }


        } else if (['Usuario', 'Empresa'].includes(role)) {
          const asesoresConectados = Array.from(this.asesores.values())
            .filter(({ socket }) => socket.connected)

          console.log(`[DEBUG] Asesores conectados actualmente: ${asesoresConectados.length}`)

          if (asesoresConectados.length === 0) {
            this.empresasPendientes.push({ userId, socket, nombreEmpresa })
            socket.emit('agent-status', false)
            socket.emit('sin-asesor', {
              msg: 'No hay agentes de soporte disponibles en este momento. Por favor, espera a que uno se conecte.'
            })
            console.log(`[WS] Empresa en espera: empresaId=${userId}, socketId=${socket.id}`)
          } else {
            const asesorEntry = asesoresConectados[0]
            const room = `chat_${userId}_${asesorEntry.userId}`
            socket.join(room)
            asesorEntry.socket.join(room)
            socket.emit('asesor-asignado', {
              asesorId: asesorEntry.userId,
              room,
              msg: '¡Te hemos asignado un agente de soporte!'
            })
            socket.emit('agent-status', true)
            asesorEntry.socket.emit('empresa-asignada', {
              empresaId: userId,
              nombreEmpresa,
              room,
              msg: 'Se te ha asignado una nueva empresa.'
            })
            this.io.to(room).emit('empresa-status', { empresaId: userId, online: true })
            this.addEmpresaAsignada(asesorEntry.userId, userId, room, nombreEmpresa)
            console.log(`[WS] Empresa asignada: empresaId=${userId}, asesorId=${asesorEntry.userId}, room=${room}`)
          }
        }
      })

      socket.on('message', ({ room, message, fromUserId }) => {
        const [empresaId] = room.replace("chat_", "").split("_")
        if (!socket.rooms.has(room)) {
          socket.join(room)
          console.warn(`[WS] El socket ${socket.id} no estaba en el room ${room}, fue agregado.`)
        }
        this.io.to(room).emit('message', { from: fromUserId, message, room })
        this.io.to(room).emit('empresa-status', { empresaId, online: true })
        console.log(`[WS] Mensaje reenviado a room=${room} de userId=${fromUserId}: ${message}`)
      })

      socket.on('finalizar-chat', ({ empresaId, room }) => {
        console.log(`[WS] Chat finalizado por asesor para empresaId=${empresaId} en room=${room}`)
        for (const [asesorId, empresas] of this.empresasAsignadas.entries()) {
          const index = empresas.findIndex(e => e.empresaId === empresaId && e.room === room)
          if (index !== -1) {
            empresas.splice(index, 1)
            console.log(`[WS] Empresa eliminada de asignación: asesorId=${asesorId}, empresaId=${empresaId}`)
          }
        }
        this.io.to(room).emit('agent-status', false)
        this.io.to(room).emit('system-message', {
          message: 'El asesor finalizó el chat.',
          from: 'system',
          type: 'chat-ended'
        })
        this.io.socketsLeave(room)
      })

      socket.on('disconnect', () => {
        if (this.asesores.has(socket.id)) {
          const { userId } = this.asesores.get(socket.id)
          const asignadas = this.empresasAsignadas.get(userId) || []
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

              const empresaSocket = Array.from(this.io.sockets.sockets.values()).find(s => s.userId === empresaId)
              if (empresaSocket?.connected) {
                this.empresasPendientes.push({
                  userId: empresaId,
                  socket: empresaSocket,
                  nombreEmpresa: empresaSocket.nombreEmpresa || 'Empresa'
                })
                empresaSocket.emit('sin-asesor', {
                  msg: 'No hay agentes de soporte disponibles en este momento. Por favor, espera a que uno se conecte.'
                })
                empresaSocket.emit('agent-status', false)
                console.log(`[DEBUG] Empresa reenviada a cola de espera: ${empresaId}`)
              }
            }
          })
          this.asesores.delete(socket.id)
          console.log(`[WS] Asesor desconectado: socketId=${socket.id}`)
        } else {
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
                empresas.splice(index, 1)
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
