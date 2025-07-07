const { assignEmpresaToAsesor } = require('../services/AssignmentService')
const { emitSinAsesor } = require('../services/statusService')

function handleJoin(socket, { userId, role, nombreEmpresa }, context) {
  if (!userId || !role) {
    console.warn(`[WS] join inválido: userId o role faltante`)
    socket.emit('error', { msg: 'Faltan datos para la conexión.' })
    return
  }

  socket.userId = userId
  socket.nombreEmpresa = nombreEmpresa || 'Empresa'

  console.log(`[DEBUG] Usuario unido: id=${userId}, role=${role}`)

  if (role === 'Asesor') {
    context.asesores.set(socket.id, { userId, socket })

    const asignadas = context.empresasAsignadas.get(userId) || []
    if (asignadas.length > 0) {
      socket.emit('empresas-asignadas', asignadas)
      asignadas.forEach(({ room }) => socket.join(room))
    } else {
      socket.emit('info', { msg: 'No tienes empresas asignadas actualmente.' })
    }

    while (context.empresasPendientes.length > 0) {
      const empresa = context.empresasPendientes.shift()
      if (!empresa.socket?.connected) continue
      assignEmpresaToAsesor(empresa, { socket, userId }, context)
    }
  } else if (['Usuario', 'Empresa'].includes(role)) {
    const asesores = Array.from(context.asesores.values())
      .filter(({ socket }) => socket.connected)

    if (asesores.length === 0) {
      context.empresasPendientes.push({ userId, socket, nombreEmpresa })
      emitSinAsesor(socket)
    } else {
      const asesor = asesores[0]
      assignEmpresaToAsesor({ userId, socket, nombreEmpresa }, asesor, context)
    }
  }
}

module.exports = handleJoin
