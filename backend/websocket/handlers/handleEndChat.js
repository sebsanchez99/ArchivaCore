const { emitAgentStatus, emitSystemMessage } = require('../services/statusService')

function handleEndChat({ empresaId, room }, context) {
  console.log(`[WS] Chat finalizado por asesor para empresaId=${empresaId} en room=${room}`)

  for (const [asesorId, empresas] of context.empresasAsignadas.entries()) {
    const index = empresas.findIndex(e => e.empresaId === empresaId && e.room === room)
    if (index !== -1) empresas.splice(index, 1)
  }

  emitAgentStatus(context.io, room, false)
  emitSystemMessage(context.io, room, 'El asesor finalizó el chat.', 'chat-ended')
  context.io.socketsLeave(room)
}

module.exports = handleEndChat
