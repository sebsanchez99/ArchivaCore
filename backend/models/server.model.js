const express = require("express");
const cors = require("cors");
const { configServer } = require("../config/config");
const router = require("../router/router");
const passport = require("../middlewares/passport/passport");

class Server {
  constructor() {
    this.app = express();
    this.port = configServer.port;
    this.routerPath = "/api/v1";
    this.middlewares();
    this.routes();
  }

  /**
   *Activa los Middlewares del servidor
   */
  middlewares() {
    this.app.use(express.json());
    this.app.use(cors());
  }

  /**
   *Selecciona la ruta del App
   */
  routes() {
    //http://localhost:3000/api/v1
    this.app.use(this.routerPath, router);
  }

  /**
   *Inicializa el servidor
   */
  init() {
    this.app.use(passport.initialize());
    this.app.use(passport.session());
    this.app.listen(this.port, () => {
      console.log(`Servidor iniciado en el puerto ${this.port}`);
    });
  }
}

module.exports = Server;
