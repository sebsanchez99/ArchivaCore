<template>
  <div class="card shadow h-[80vh] flex flex-col">
    <!-- Header -->
    <div class="bg-primary-100 text-text-700 rounded-t-md p-4">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2">
          <ChatBubbleBottomCenterTextIcon class="w-5 text-accent-500" />
          <h2 class="text-lg font-semibold">Chat en vivo</h2>
        </div>
        <span class="badge text-xs border-none" :class="statusClass">
          {{ connectionLabel }}
        </span>
      </div>
      <p class="text-sm opacity-80 mt-1">Tiempo de respuesta estimado: 3 minutos</p>
    </div>

    <!-- Body -->
    <div class="flex-1 overflow-hidden bg-white p-4">
      <div v-if="chatStore.loading" class="flex flex-col items-center justify-center h-full">
        <svg class="animate-spin h-8 w-8 text-secondary-500 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
        </svg>
        <span class="text-secondary-500 font-semibold">Cargando chat...</span>
      </div>

      <!-- Antes de iniciar -->
      <div v-else-if="!chatStarted" class="flex flex-col items-center text-center h-full justify-between">
        <div>
          <div class="avatar mb-4">
            <div class="bg-primary-100 text-primary-600 rounded-full p-4 shadow">
              <UserIcon class="w-10" />
            </div>
          </div>
          <h3 class="text-lg font-semibold text-text-500">Soporte instantáneo</h3>
          <p class="text-sm text-text-400 opacity-85 max-w-xs">
            Nuestros agentes de soporte están disponibles para ayudarlo con cualquier pregunta o problema.
          </p>
          <div class="mt-4 w-full">
            <div class="flex justify-center items-center gap-2 bg-primary-100 p-2 rounded-lg text-sm text-text-400">
              <ClockIcon class="w-5 text-accent-500" />
              Lunes a Viernes: 9:00 AM - 5:00 PM
            </div>
          </div>
        </div>
        <button class="btn btn-outline bg-green-500 border-none w-full mt-4 text-white hover:bg-green-600" @click="startChat">
          <PowerIcon class="w-5 mr-2" />
          Iniciar chat ahora
        </button>
      </div>

      <!-- Chat activo -->
      <div v-else class="flex flex-col h-full">
        <!-- Agente -->
        <div class="pb-2 border-b border-primary-500 flex justify-between items-center">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 bg-primary-100 p-1 rounded-full">
              <UserIcon class="text-primary-500" />
            </div>
            <div>
              <p class="font-semibold">Agente de soporte</p>
              <p class="text-xs" :class="chatStore.agentOnline ? 'text-green-500' : 'text-red-500'">
                {{ chatStore.agentOnline ? 'En línea' : 'Desconectado' }}
              </p>
            </div>
          </div>
          <button @click="endChat" class="btn btn-sm border-none bg-red-500 text-white">
            <PowerIcon class="w-4 text-white mr-1" />
            Finalizar chat
          </button>
        </div>

        <!-- Mensajes -->
        <div ref="chatContainer" class="flex-1 overflow-y-auto py-4 space-y-2 scroll-smooth">
          <div v-for="(msg, index) in chatStore.messages[empresaId] || []" :key="index">
            <div v-if="msg.from === 'system'" class="text-center my-2">
              <span class="inline-block bg-gray-200 text-gray-700 text-xs px-3 py-1 rounded-full shadow-sm">
                {{ msg.text }}
              </span>
            </div>
            <div v-else :class="getMessageClass(msg.from)">
              <div v-if="msg.from === 'agent'" class="chat-image avatar pa-3">
                <div class="bg-accent-200 text-white rounded-full p-3 shadow font-bold">AS</div>
              </div>
              <div class="chat-header text-xs text-text-300 flex justify-between ml-2 font-semibold">
                {{ getMessageHeader(msg.from) }}
                <time class="ml-2">{{ msg.time }}</time>
              </div>
              <div class="chat-bubble text-text-400 text-sm bg-primary-100">
                {{ msg.text }}
              </div>
            </div>
          </div>
        </div>

        <!-- Reconectando -->
        <div v-if="chatStore.connectionStatus === 'reconnecting' && !chatStore.connected"
          class="absolute inset-0 z-10 bg-white/80 flex flex-col items-center justify-center text-center px-4">
          <svg class="animate-spin h-8 w-8 text-primary-500 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
          </svg>
          <p class="text-sm text-gray-600 font-semibold">Reconectando con el servidor...</p>
        </div>

        <!-- Input -->
        <div class="pt-2 border-t border-primary-500">
          <div v-if="chatStore.connectionStatus !== 'online'" class="flex items-center justify-center gap-2 py-4">
            <span class="loading loading-spinner text-primary-500"></span>
            <span class="text-sm text-gray-500 font-medium">
              Parece que hay problemas de conexión. Intentando reconectar...
            </span>
          </div>
          <div v-else class="flex gap-2 items-center">
            <input v-model="input" @keyup.enter="sendMessage" type="text" placeholder="Escribe un mensaje..."
              class="input w-full border border-primary-500 bg-white text-black" />
            <button @click="sendMessage" class="btn btn-primary bg-primary-500 border-none">
              <PaperAirplaneIcon class="w-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, onUnmounted, computed } from "vue";
import { useRoute } from "vue-router";
import { ChatBubbleBottomCenterTextIcon, PaperAirplaneIcon, PowerIcon, ClockIcon } from "@heroicons/vue/24/outline";
import { UserIcon } from "@heroicons/vue/24/solid";
import { useChatStore } from "@/stores/chatStore";
import { useAuthStore } from "@/stores/authStore";
import {
  connectChat,
  sendMessageToRoom,
  onMessage,
  onAgentStatus,
  disconnectChat,
  onSocketConnect,
  onSocketDisconnect,
  onSocketReconnecting,
  onSocketError,
  onAsesorAsignado,
  onSinAsesor,
  onSystemMessage,
  offAllChatListeners
} from "@/services/chatService";
import type { ChatMessage } from "@/interfaces/chat";

const route = useRoute();
const chatStore = useChatStore();
const authStore = useAuthStore();

const empresaId = authStore.getCompanyId;
const companyName = authStore.getCompanyName || "Empresa";
const role = authStore.getRol || "Usuario";

const chatStarted = computed({
  get: () => chatStore.chatStarted,
  set: (value) => chatStore.setChatStarted(value)
});

const input = ref("");
const chatContainer = ref<HTMLElement | null>(null);
let connectingTimeout: ReturnType<typeof setTimeout> | null = null;

const statusClass = computed(() => {
  const status = chatStore.connectionStatus;
  return {
    online: "bg-green-500 text-white",
    connecting: "bg-yellow-500 text-white",
    reconnecting: "bg-yellow-500 text-white",
    offline: "bg-primary-500 text-white"
  }[status];
});

const connectionLabel = computed(() => {
  const status = chatStore.connectionStatus;
  return {
    online: "En línea",
    connecting: "Conectando...",
    reconnecting: "Reestableciendo conexión...",
    offline: "Desconectado"
  }[status];
});

function startChat() {
  chatStarted.value = true;
  chatStore.markAsRead(empresaId);
  chatStore.clearMessages(empresaId);
  chatStore.setConnectionStatus("connecting");
  chatStore.setRoom(empresaId, "");
  disconnectChat();
  offAllChatListeners();

  connectChat(empresaId, role, companyName);
  connectingTimeout = setTimeout(() => {
    if (chatStore.connectionStatus === "connecting") {
      chatStore.setLoading(true);
    }
  }, 2000);

  onSocketConnect(() => {
    if (connectingTimeout) clearTimeout(connectingTimeout);
    chatStore.setConnected(true);
    chatStore.setConnectionStatus("online");
    chatStore.setLoading(false);
  });

  onSocketDisconnect(() => {
    chatStore.setConnected(false);
    chatStore.setAgentOnline(false);
    chatStore.setConnectionStatus("offline");
    chatStore.setLoading(false);
  });
  
  onSocketReconnecting(() => {
    chatStore.setConnectionStatus("reconnecting");
    chatStore.setAgentOnline(false);
    chatStore.setLoading(false);
  });

  onSocketError(() => {
    chatStore.setConnectionStatus("offline");
    chatStore.setLoading(false);
  });

  onAsesorAsignado(({ room }) => {
    chatStore.setRoom(empresaId, room);
    chatStore.addMessageToChat(empresaId, "¡Te hemos asignado un agente de soporte!", "agent");
  });

  onSinAsesor(({ msg }) => {
    chatStore.setRoom(empresaId, "");
    chatStore.addMessageToChat(empresaId, msg, "agent");
  });

  onMessage((msg) => {
    const msgFrom = msg.from === empresaId ? "user" : "agent";
    chatStore.addMessageToChat(empresaId, msg.message, msgFrom);

    const isVisible = route.path.includes("/dashboard/support") && document.visibilityState === "visible";
    if (chatStarted.value && isVisible) chatStore.markAsRead(empresaId);
    else if (msgFrom === "agent") chatStore.markAsUnread(empresaId);
  });

  onAgentStatus(chatStore.setAgentOnline);

  onSystemMessage(({ message }) => {
    chatStore.addMessageToChat(empresaId, message, "system");
  });

  setTimeout(() => chatStore.setLoading(false), 1000);
}

function sendMessage() {
  if (!input.value.trim()) return;
  const room = chatStore.rooms[empresaId];
  if (room) sendMessageToRoom(room, input.value, empresaId);
  input.value = "";
}

function endChat() {
  chatStarted.value = false;
  chatStore.clearMessages(empresaId);
  resetChatState();
}

function resetChatState() {
  disconnectChat();
  chatStore.setConnected(false);
  chatStore.setAgentOnline(false);
  chatStore.setConnectionStatus("offline");
  chatStore.setRoom(empresaId, "");
}

function getMessageClass(from: ChatMessage["from"]) {
  return from === "agent" ? "chat chat-start" : "chat chat-end";
}

function getMessageHeader(from: ChatMessage["from"]) {
  return from === "agent" ? "Agente Soporte" : "Tú";
}

watch(() => chatStore.messages[empresaId], async () => {
  await nextTick();
  chatContainer.value?.scrollTo({ top: chatContainer.value.scrollHeight, behavior: "smooth" });
}, { deep: true });

watch(() => route.path, (path) => {
  if (path.includes("/dashboard/support") && chatStarted.value && chatStore.hasUnreadMessages(empresaId)) {
    chatStore.markAsRead(empresaId);
  }
}, { immediate: true });

onUnmounted(resetChatState);
</script>
