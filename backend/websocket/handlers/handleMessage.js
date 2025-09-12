const { emitEmpresaStatus } = require('../services/statusService.js')

function handleMessage(socket, { room, message, fromUserId }, context) {
  const [empresaId] = room.replace("chat_", "").split("_")

  if (!socket.rooms.has(room)) {
    socket.join(room)
    console.warn(`[WS] El socket ${socket.id} no estaba en el room ${room}, fue agregado.`)
  }

  context.io.to(room).emit('message', { from: fromUserId, message, room })
  emitEmpresaStatus(context.io, room, empresaId, true)

  console.log(`[WS] Mensaje reenviado a room=${room} de userId=${fromUserId}: ${message}`)
}

module.exports = handleMessage
