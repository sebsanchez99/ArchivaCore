const { Server } = require("socket.io");

class WebSocketServer {
  constructor(server) {
    this.io = new Server(server, {
      connectionStateRecovery: {},
      cors: { origins: "*" },
    });
  }

  init() {
    this.io.on("connection", (socket) => {
      console.log("Cliente conectado " + socket.id);
      socket.on("message", (msg) => {
        console.log("Mensaje recibido:", msg);
        socket.io.emit("message", msg);
      });

      socket.on("join room", async (roomId) => {
        await socket.join(roomId);
      });

      socket.on("leave room", async (roomId) => {
        await socket.leave(roomId);
      });

      socket.on("disconnect", () => {
        console.log("Cliente desconectado");
      });
    });
  }
}

module.exports = WebSocketServer;
