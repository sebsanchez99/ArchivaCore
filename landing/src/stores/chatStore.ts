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
    unreadMessages: {} as Record<string, number>,
    chatStarted: false,
  }),

  actions: {
    setChatStarted(value: boolean) {
      this.chatStarted = value;
    },

    addMessageToChat(chatId: string, text: string, from: ChatMessage["from"]) {
      const time = new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });

      if (!this.messages[chatId]) {
        this.messages[chatId] = [];
      }

      this.messages[chatId].push({ text, from, time });
    },

    clearMessages(chatId?: string) {
      if (chatId) {
        delete this.messages[chatId];
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

    markAsUnread(chatId: string) {
      this.unreadMessages[chatId] = (this.unreadMessages[chatId] || 0) + 1;
    },

    markAsRead(chatId: string) {
      this.unreadMessages[chatId] = 0;
    },

    hasUnreadMessages(chatId: string): boolean {
      return (this.unreadMessages[chatId] || 0) > 0;
    },
  },
});
