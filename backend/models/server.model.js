/**
 * @namespace Modelos
 * @description Modelos de la aplicación.
 */
const express = require("express")
const cors = require("cors")
const { createServer } = require("node:http")
const { configServer } = require("../config/config.js")
const router = require("../router/router.js")
const passport = require("../middlewares/passport/passport.js")
const WebSocketServer = require("../websocket/websocketserver.js")

/**
 * Representa el servidor Express.
 * @memberof Modelos
 * @class
 * @description Esta clase inicializa el servidor Express y configura las rutas y middlewares.
 */
class Server {
  
  /**
   * @constructor
   */
  constructor() {
    this.app = express()
    this.port = configServer.port
    this.routerPath = "/api/v1"
    this.middlewares()
    this.routes()
    this.server = createServer(this.app)
    this.io = new WebSocketServer(this.server)
  }

  /**
   * Configura los Middlewares del servidor
   */
  middlewares() {
    this.app.use(express.json())
    this.app.use(cors())
  }

  /**
   * Configura las rutas de la aplicación
   */
  routes() {
    //http://localhost:3000/api/v1
    this.app.use(this.routerPath, router)
  }

  /**
   * Inicializa el servidor
   */
  init() {
    this.app.use(passport.initialize())
    this.io.init() 
    this.server.listen(this.port, () => {
      console.log(`Servidor iniciado en el puerto ${this.port}`)
    })
  }
}

module.exports = Server
