import { defineStore } from "pinia";
import type { ChatMessage } from "@/interfaces/chat";

export type ChatConnectionStatus = "offline" | "connecting" | "online" | "reconnecting";

export const useChatStore = defineStore("chat", {
  state: () => ({
    messages: {} as Record<string, ChatMessage[]>,
    connected: false,
    agentOnline: false,
    loading: false,
    connectionStatus: "offline" as ChatConnectionStatus,
    rooms: {} as Record<string, string>,
    chatStarted: false,
  }),
  actions: {
    setChatStarted(value: boolean) {
      this.chatStarted = value;
    },

    addMessageToChat(chatId: string, text: string, from: "user" | "agent" | "system") {
      const now = new Date();
      const time = now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
      if (!this.messages[chatId]) this.messages[chatId] = [];
      this.messages[chatId].push({ text, from, time });
    },
    clearMessages(chatId?: string) {
      if (chatId) {
        this.messages[chatId] = [];
      } else {
        this.messages = {};
      }
    },
    setConnected(status: boolean) {
      this.connected = status;
      this.connectionStatus = status ? "online" : "offline";
    },
    setAgentOnline(status: boolean) {
      this.agentOnline = status;
    },
    setLoading(status: boolean) {
      this.loading = status;
    },
    setConnectionStatus(status: ChatConnectionStatus) {
      this.connectionStatus = status;
    },
    setRoom(chatId: string, room: string) {
      this.rooms[chatId] = room;
    },
  },
});