function emitAgentStatus(io, room, online) {
  io.to(room).emit('agent-status', online)
}

function emitEmpresaStatus(io, room, empresaId, online) {
  io.to(room).emit('empresa-status', { empresaId, online })
}

function emitSystemMessage(io, room, message, type) {
  io.to(room).emit('system-message', {
    message,
    from: 'system',
    type,
  })
}

function emitSinAsesor(socket) {
  socket.emit('agent-status', false)
  socket.emit('sin-asesor', {
    msg: 'No hay agentes de soporte disponibles en este momento. Por favor, espera a que uno se conecte.',
  })
}

module.exports = {
  emitAgentStatus,
  emitEmpresaStatus,
  emitSystemMessage,
  emitSinAsesor,
}
