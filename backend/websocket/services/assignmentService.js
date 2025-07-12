function assignEmpresaToAsesor(empresa, asesor, context) {
  const { userId: empresaId, socket: socketEmpresa, nombreEmpresa } = empresa
  const { userId: asesorId, socket: socketAsesor } = asesor

  const room = `chat_${empresaId}_${asesorId}`
  socketEmpresa.join(room)
  socketAsesor.join(room)

  socketEmpresa.emit('asesor-asignado', {
    asesorId,
    room,
    msg: '¡Te hemos asignado un agente de soporte!'
  })
  socketEmpresa.emit('agent-status', true)

  socketAsesor.emit('empresa-asignada', {
    empresaId,
    nombreEmpresa,
    room,
    msg: 'Se te ha asignado una nueva empresa.'
  })

  context.io.to(room).emit('empresa-status', { empresaId, online: true })

  if (!context.empresasAsignadas.has(asesorId)) {
    context.empresasAsignadas.set(asesorId, [])
  }
  const asignadas = context.empresasAsignadas.get(asesorId)
  if (!asignadas.some(e => e.empresaId === empresaId && e.room === room)) {
    asignadas.push({ empresaId, room, nombreEmpresa })
  }

  console.log(`[WS] Empresa asignada: empresaId=${empresaId}, asesorId=${asesorId}, room=${room}`)
}

module.exports = { assignEmpresaToAsesor }
