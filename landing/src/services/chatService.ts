import { io, Socket } from "socket.io-client";

let socket: Socket | null = null;

/**
 * Conecta al chat y emite el evento join con userId y role.
 */
export function connectChat(userId: string, role: string, companyName?: string) {
  if (!socket) {
    console.log("[Chat] Conectando socket...", userId, role);
    socket = io(import.meta.env.VITE_API_URL || "ws://localhost:3000");
    socket.on("connect", () => {
      socket?.emit("join", { userId, role, nombreEmpresa: companyName });
    });
  } else {
    console.log("[Chat] Ya hay un socket conectado");
  }
  return socket;
}

export function cleanAllListeners() {
  if (!socket) return;
  socket.removeAllListeners(); // 🔥 Quita TODO de una vez
}


export function onSocketConnect(callback: () => void) {
  if (socket) socket.on("connect", callback);
}

export function onSocketDisconnect(callback: () => void) {
  if (socket) socket.on("disconnect", callback);
}

export function onSocketReconnecting(callback: () => void) {
  if (socket) socket.on("reconnect_attempt", callback);
}

export function onSocketConnecting(callback: () => void) {
  if (socket) socket.on("connecting", callback);
}

export function onSocketError(callback: () => void) {
  if (socket) socket.on("connect_error", callback);
}

/**
 * Escucha cuando una empresa es asignada a un asesor.
 */
export function onAsesorAsignado(callback: (data: { asesorId: string, room: string }) => void) {
  if (socket) socket.on("asesor-asignado", callback);
}

/**
 * Escucha cuando un asesor recibe una empresa.
 */
export function onEmpresaAsignada(callback: (data: { empresaId: string, nombreEmpresa: string, room: string }) => void) {
  if (socket) socket.on("empresa-asignada", callback);
}

/**
 * Escucha cuando no hay asesores disponibles.
 */
export function onSinAsesor(callback: (data: { msg: string }) => void) {
  if (socket) socket.on("sin-asesor", callback);
}

/**
 * Envía un mensaje a una sala específica.
 */
export function sendMessageToRoom(room: string, message: string, fromUserId: string) {
  if (socket) {
    socket.emit("message", { room, message, fromUserId });
  }
}

export function onEmpresasAsignadas(callback: (empresas: { empresaId: string, nombreEmpresa: string, room: string }[]) => void) {
  if (socket) socket.on("empresas-asignadas", callback);
}

/**
 * Escucha mensajes recibidos.
 */
export function onMessage(callback: (msg: { from: string; message: string, room: string }) => void) {
  if (socket) {
    socket.on("message", callback);
  }
}

/**
 * Escucha el estado del agente.
 */
export function onAgentStatus(callback: (status: boolean) => void) {
  if (socket) {
    socket.on("agent-status", callback);
  }
}

export function onEmpresaStatus(callback: (data: { empresaId: string, online: boolean }) => void) {
  if (socket) socket.on("empresa-status", callback);
}

export function onSystemMessage(callback: (data: { message: string, from: string, type: string }) => void) {
  if (socket) socket.on("system-message", callback);
}

// chatService.ts
export function offAllChatListeners() {
  if (!socket) return;
  socket.off("connect");
  socket.off("disconnect");
  socket.off("reconnect_attempt");
  socket.off("connect_error");
  socket.off("asesor-asignado");
  socket.off("sin-asesor");
  socket.off("message");
  socket.off("agent-status");
  socket.off("system-message");
}

/**
 * Desconecta el chat.
 */
export function disconnectChat() {
  if (socket) {
    cleanAllListeners()
    socket.disconnect();
    socket = null;
  }
}