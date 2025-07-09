<template>
  <div class="flex-1 flex flex-col h-full">
    <!-- Sin chat seleccionado -->
    <div v-if="!chat" class="flex flex-col items-center justify-center flex-1 text-center text-text-500">
      <div class="avatar mb-4">
        <div class="w-20 rounded-full bg-primary-100 p-4">
          <ChatBubbleBottomCenterTextIcon class="text-primary-600 w-12 h-12" />
        </div>
      </div>
      <h3 class="text-xl font-semibold">Selecciona un chat</h3>
      <p class="text-sm text-text-400">Aquí podrás ver y responder mensajes de los clientes</p>
    </div>

    <!-- Chat activo -->
    <div v-else class="flex flex-col h-full">
      <!-- Cabecera -->
      <div class="pb-2 border-b border-primary-500 flex justify-between items-center">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 bg-gray-200 rounded-full">
            <UserIcon class="text-primary-500" />
          </div>
          <div>
            <p class="font-semibold">{{ chat.name }}</p>
            <p class="text-xs" :class="chat.online ? 'text-green-500' : 'text-gray-400'">
              {{ chat.online ? 'En línea' : 'Desconectado' }}
            </p>
          </div>
        </div>
        <button @click="endChat" class="btn btn-sm border-none bg-red-500 text-white">
          Finalizar chat
        </button>
      </div>

      <!-- Mensajes -->
      <div ref="chatContainer" class="flex-1 overflow-y-auto py-4 space-y-4 scroll-smooth">
        <div v-for="(msg, index) in messages" :key="index">
          <!-- Mensaje del sistema -->
          <div v-if="msg.from === 'system'" class="text-center my-2">
            <span class="inline-block bg-gray-200 text-gray-700 text-xs px-3 py-1 rounded-full shadow-sm">
              {{ msg.text }}
            </span>
          </div>

          <!-- Mensajes normales -->
          <div v-else :class="getMessageClass(msg.from)">
            <template v-if="msg.from === 'user'">
              <div class="chat-image avatar mr-2">
                <div class="bg-accent-200 text-white rounded-full font-bold p-3 shadow">
                  {{ getInitials(chat.name) }}
                </div>
              </div>
            </template>
            <div>
              <div class="chat-header text-xs text-primary-600 flex justify-between ml-2 font-semibold">
                {{ msg.from === 'agent' ? 'Agente Soporte' : chat.name }}
                <time class="ml-2">{{ msg.time }}</time>
              </div>
              <div class="chat-bubble text-text-400 text-sm bg-primary-100">
                {{ msg.text }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Input o reconexión -->
      <div class="pt-2 border-t border-primary-500">
        <div v-if="chatStore.connectionStatus !== 'online'" class="flex items-center justify-center gap-2 py-4">
          <span class="loading loading-spinner text-primary-500"></span>
          <span class="text-sm text-gray-500 font-medium">
            Parece que hay problemas de conexión. Intentando reconectar...
          </span>
        </div>
        <div v-else class="flex gap-2 items-center">
          <input
            v-model="input"
            @keyup.enter="sendMessage"
            type="text"
            placeholder="Escribe un mensaje..."
            class="input w-full bg-white border border-primary-500"
          />
          <button @click="sendMessage" class="btn btn-primary bg-primary-500 border-none">
            <PaperAirplaneIcon class="w-5" />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, onMounted, onUnmounted, onUpdated, computed } from "vue";
import {
  ChatBubbleBottomCenterTextIcon,
  PaperAirplaneIcon,
} from "@heroicons/vue/24/outline";
import { UserIcon } from "@heroicons/vue/24/solid";

import { useChatStore } from "@/stores/chatStore";
import { useAuthStore } from "@/stores/authStore";
import {
  sendMessageToRoom,
  endChat as endChatService,
  onSystemMessage,
  offSystemMessage
} from "@/services/chatService";

import type { ChatMessage } from "@/interfaces/chat";

// Props y emits
const props = defineProps<{ chat: any; messages: ChatMessage[] }>();
const emit = defineEmits<{
  (e: "chatFinalizado", id: string): void;
}>();

// Stores
const chatStore = useChatStore();
const authStore = useAuthStore();
const userId = authStore.getUserId;

// Estado interno
const input = ref("");
const chatContainer = ref<HTMLElement | null>(null);

// Room actual
const room = computed(() => chatStore.rooms[props.chat?.id]);

function sendMessage() {
  if (!input.value.trim() || !room.value || !props.chat) return;
  sendMessageToRoom(room.value, input.value, userId);
  input.value = "";
}

function endChat() {
  if (!props.chat || !room.value) return;
  endChatService(props.chat.id, room.value);
  chatStore.clearMessages(props.chat.id);
  emit("chatFinalizado", props.chat.id);
  input.value = "";
}

function getInitials(name: string): string {
  return name.trim().substring(0, 2).toUpperCase();
}

function scrollToBottom() {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
    }
  });
}

function getMessageClass(from: ChatMessage["from"]): string {
  if (from === "agent") return "chat chat-end";
  if (from === "system") return "chat chat-center";
  return "chat chat-start";
}

// Actualizar scroll cuando llegan mensajes
watch(() => props.messages, scrollToBottom, { deep: true });
onUpdated(scrollToBottom);

// Escucha de mensajes del sistema
function handleSystemMessage(data: any) {
  if (!props.chat) return;

  const rol = authStore.getRol;
  if ((data.type === "agent-disconnect" && rol === "Asesor") ||
      (data.type === "user-disconnect" && rol === "Empresa")) {
    return;
  }

  chatStore.addMessageToChat(props.chat.id, data.message, "system");
}

onMounted(() => {
  onSystemMessage(handleSystemMessage);
});

onUnmounted(() => {
  offSystemMessage(handleSystemMessage);
});
</script>
