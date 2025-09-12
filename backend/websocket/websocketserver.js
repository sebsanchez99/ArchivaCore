const { Server } = require('socket.io')

const handleJoin = require('./handlers/handleJoin.js')
const handleMessage = require('./handlers/handleMessage.js')
const handleEndChat = require('./handlers/handleEndChat.js')
const handleDisconnect = require('./handlers/handleDisconnect.js')

class WebSocketServer {
  constructor(server) {
    this.io = new Server(server, {
      connectionStateRecovery: {},
      cors: { origin: '*' },
    })
    this.asesores = new Map()
    this.empresasPendientes = []
    this.empresasAsignadas = new Map()
  }

  init() {
    this.io.on('connection', (socket) => {
      console.log(`[WS] Nueva conexión: ${socket.id}`)

      socket.on('join', (data) => handleJoin(socket, data, this))
      socket.on('message', (data) => handleMessage(socket, data, this))
      socket.on('finalizar-chat', (data) => handleEndChat(data, this))
      socket.on('disconnect', () => handleDisconnect(socket, this))
    })
  }
}

module.exports = WebSocketServer
