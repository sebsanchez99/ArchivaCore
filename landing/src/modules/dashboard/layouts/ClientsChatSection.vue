<template>
  <div class="max-w-7xl mx-auto px-4 py-6 h-[83vh] flex items-center justify-center">
    <template v-if="!connected">
      <div
        class="w-full flex flex-col items-center justify-center h-full text-center px-6 py-10">
        <!-- Ícono decorativo animado -->
        <div class="relative mb-8">
          <div class="absolute -inset-4 bg-primary-100 rounded-full blur-xl opacity-40 animate-ping"></div>
          <div class="bg-primary-100 rounded-full p-6 shadow-lg relative z-10">
            <ChatBubbleOvalLeftEllipsisIcon class="h-16 w-16 text-primary-500" />
          </div>
        </div>

        <!-- Bienvenida -->
        <h2 class="text-4xl font-extrabold text-primary-700 mb-2">
          ¡Listo para ayudar, {{ authStore.getFullname }}!
        </h2>

        <!-- Subtítulo -->
        <p class="text-base text-gray-600 max-w-md mb-6 leading-relaxed">
          Esta es tu consola de soporte.
          Aquí recibirás y responderás mensajes de clientes en tiempo real.
          <span class="block mt-3 text-sm text-primary-400 font-semibold">
            Recuerda conectarte para empezar a atender solicitudes.
          </span>
        </p>

        <!-- Rol -->
        <p class="mb-8 text-sm text-gray-500">
          Rol: <span class="text-primary-600 font-medium">{{ authStore.getRol }}</span>
        </p>

        <!-- Botón de conexión -->
        <button
          class="btn bg-primary-500 text-white text-lg font-medium shadow-lg hover:shadow-xl hover:bg-primary-600 px-6 py-3 flex items-center gap-2 transition-all duration-200 border-none"
          @click="connectSupport">
          <ArrowRightOnRectangleIcon class="h-5 w-5" />
          Conectarme como soporte
        </button>
      </div>
    </template>

    <template v-else>
      <div class="grid grid-cols-12 gap-4 w-full h-full">
        <div class="col-span-4 bg-primary-200 rounded-lg shadow p-4 overflow-y-auto">
          <ChatListPanel :chats="chats" :selectedChatId="selectedChatId" @selectChat="selectChat" />
        </div>
        <div class="col-span-8 bg-white rounded-lg shadow p-0 flex flex-col relative overflow-hidden">
          <!-- 🔔 Barra de estado (sin transición) -->
          <ConnectionStatusBar :connectionStatus="connectionStatus" @disconnect="handleDisconnect" />

          <!-- 💬 Área del chat -->
          <div class="p-4 flex-1 overflow-y-auto relative">
            <template v-if="selectedChat">
              <ChatDetails :chat="selectedChat" :messages="selectedChatMessages" @chatFinalizado="onFinalizedChat" />
            </template>
            <template v-else>
              <!-- Mensaje de reconexión si no hay chat -->
              <div v-if="connectionStatus !== 'online'" class="flex flex-col items-center justify-center h-full gap-4">
                <span class="loading loading-spinner text-primary-500 w-8 h-8"></span>
                <p class="text-sm text-gray-500 font-medium text-center max-w-xs">
                  Parece que hay problemas de conexión. Intentando reconectar...
                </p>
              </div>
              <!-- Mensaje neutro cuando no hay chats activos -->
              <div v-else class="flex flex-col items-center justify-center h-full text-center text-text-500">
                <div class="avatar mb-4">
                  <div class="w-20 rounded-full bg-primary-100 p-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-primary-600 w-12 h-12" fill="none"
                      viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M8 10h.01M12 10h.01M16 10h.01M21 12c0 4.418-4.03 8-9 8s-9-3.582-9-8 4.03-8 9-8 9 3.582 9 8z" />
                    </svg>
                  </div>
                </div>
                <h3 class="text-xl font-semibold">Selecciona un chat</h3>
                <p class="text-sm text-text-400">Aquí podrás ver y responder mensajes de los clientes</p>
              </div>
            </template>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script lang="ts" setup>
import { ref, computed } from 'vue';
import {
  connectChat,
  disconnectChat,
  onEmpresaAsignada,
  onEmpresasAsignadas,
  onEmpresaStatus,
  onMessage,
  onSocketConnect,
  onSocketDisconnect,
  onSocketReconnecting,
  onSocketError,
} from "@/services/chatService";

import { useChatStore } from "@/stores/chatStore";
import { useAuthStore } from "@/stores/authStore";

import ChatListPanel from "@/modules/dashboard/components/ClientsChatSection/ChatListPanel.vue";
import ChatDetails from "@/modules/dashboard/components/ClientsChatSection/ChatDetails.vue";
import ConnectionStatusBar from "@/modules/dashboard/components/ClientsChatSection/ConnectionStatusBar.vue";
import type { Chat } from "@/interfaces/chat";

import {
  ChatBubbleOvalLeftEllipsisIcon,
  ArrowRightOnRectangleIcon,
} from '@heroicons/vue/24/outline'

const chatStore = useChatStore();
const authStore = useAuthStore();

const username = authStore.getUsername;
const userId = authStore.getUserId;
const role = authStore.getRol;

const chats = ref<Chat[]>([]);
const selectedChatId = ref<string | null>(null);
const connected = ref(false);

const connectionStatus = computed(() => chatStore.connectionStatus);
const selectedChat = computed(() =>
  chats.value.find(chat => chat.id === selectedChatId.value) || null
);

const selectedChatMessages = computed(() => {
  if (!selectedChat.value) return [];
  return chatStore.messages[selectedChat.value.id] || [];
});

function getCurrentTime(): string {
  return new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
}

function selectChat(id: string) {
  selectedChatId.value = id;
  if (chatStore.connected) chatStore.markAsRead(id);
}

function connectSupport() {
  chatStore.setConnectionStatus('connecting');
  connectChat(userId, "Asesor");
  connected.value = true;

  onSocketConnect(() => {
    chatStore.setConnected(true);
    chatStore.setConnectionStatus("online");
  });

  onSocketDisconnect(() => {
    chatStore.setConnected(false);
    chatStore.setConnectionStatus("offline");
    chats.value.forEach(chat => {
      chat.online = false;
      if (selectedChatId.value !== chat.id) {
        chatStore.markAsUnread(chat.id);
      }
    });
  });

  onSocketReconnecting(() => {
    chatStore.setConnectionStatus("reconnecting");
    chats.value.forEach(chat => chat.online = false);
  });
  onSocketError(() => chatStore.setConnectionStatus("offline"));

  onEmpresaAsignada(({ empresaId, room, nombreEmpresa }) => {
    addOrUpdateChat(empresaId, room, nombreEmpresa);
  });

  onEmpresasAsignadas(empresas => {
    empresas.forEach(({ empresaId, room, nombreEmpresa }) => {
      addOrUpdateChat(empresaId, room, nombreEmpresa);
    });
  });

  onEmpresaStatus(({ empresaId, online }) => {
    const chat = chats.value.find(c => c.id === empresaId);
    if (chat) chat.online = online;
  });

  onMessage(({ from, message, room }) => {
    const chatId = Object.keys(chatStore.rooms).find(id => chatStore.rooms[id] === room);
    if (!chatId) return;

    const fromType = from === userId ? "agent" : "user";
    chatStore.addMessageToChat(chatId, message, fromType);

    const chat = chats.value.find(c => c.id === chatId);
    if (chat) chat.time = getCurrentTime();

    if (selectedChatId.value !== chatId) {
      chatStore.markAsUnread(chatId);
    }
  });
}

function handleDisconnect() {
  disconnectChat();
  resetChatState();
}

function resetChatState() {
  connected.value = false;
  chats.value = [];
  selectedChatId.value = null;
  chatStore.clearMessages();
  chatStore.setRoom("", "");
  chatStore.setConnected(false);
  chatStore.setConnectionStatus("offline");
}

function onFinalizedChat(chatId: string) {
  chats.value = chats.value.filter(chat => chat.id !== chatId);
  chatStore.clearMessages(chatId);
  chatStore.setRoom(chatId, "");
  if (selectedChatId.value === chatId) {
    selectedChatId.value = null;
  }
}

function addOrUpdateChat(empresaId: string, room: string, nombreEmpresa: string) {
  let chat = chats.value.find(c => c.id === empresaId);
  if (!chat) {
    chat = {
      id: empresaId,
      name: nombreEmpresa,
      online: true,
      time: getCurrentTime(),
      messages: [],
    };
    chats.value.push(chat);
    if (!selectedChatId.value) selectedChatId.value = empresaId;
  }

  chatStore.setRoom(empresaId, room);

  if (selectedChatId.value === empresaId) {
    chatStore.setRoom(empresaId, room);
  }
}

defineOptions({ name: 'ClientsChatSection' });
</script>
