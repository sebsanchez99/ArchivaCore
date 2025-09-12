const {
  emitAgentStatus,
  emitEmpresaStatus,
  emitSystemMessage,
  emitSinAsesor
} = require('../services/statusService.js')

function handleDisconnect(socket, context) {
  if (context.asesores.has(socket.id)) {
    const { userId: asesorId } = context.asesores.get(socket.id)
    const asignadas = context.empresasAsignadas.get(asesorId) || []
    const roomsNotificados = new Set()

    asignadas.forEach(({ empresaId, room }) => {
      if (roomsNotificados.has(room)) return

      emitAgentStatus(context.io, room, false)
      emitSystemMessage(context.io, room, 'El asesor se ha desconectado.', 'agent-disconnect')
      roomsNotificados.add(room)

      const empresaSocket = Array.from(context.io.sockets.sockets.values())
        .find(s => s.userId === empresaId)

      if (empresaSocket?.connected) {
        context.empresasPendientes.push({
          userId: empresaId,
          socket: empresaSocket,
          nombreEmpresa: empresaSocket.nombreEmpresa || 'Empresa'
        })
        emitSinAsesor(empresaSocket)
        console.log(`[DEBUG] Empresa reenviada a cola de espera: ${empresaId}`)
      }
    })

    context.asesores.delete(socket.id)
    console.log(`[WS] Asesor desconectado: socketId=${socket.id}`)
  } else {
    const empresaId = socket.userId
    if (!empresaId) {
      console.log(`[WS] Cliente desconectado: socketId=${socket.id}`)
      return
    }

    for (const empresas of context.empresasAsignadas.values()) {
      const index = empresas.findIndex(e => e.empresaId === empresaId)
      if (index !== -1) {
        const { room } = empresas[index]
        emitEmpresaStatus(context.io, room, empresaId, false)
        emitSystemMessage(context.io, room, 'El usuario se ha desconectado.', 'user-disconnect')
        empresas.splice(index, 1)
      }
    }

    console.log(`[WS] Empresa desconectada: empresaId=${empresaId}, socketId=${socket.id}`)
  }
}

module.exports = handleDisconnect
