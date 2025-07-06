<template>
  <div class="max-w-6xl mx-auto px-4 py-6 h-[85vh] flex items-center justify-center">
    <template v-if="!connected">
      <div class="w-full flex flex-col items-center justify-center h-full">
        <div class="bg-primary-100 rounded-full p-6 shadow mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-14 w-14 text-primary-500" fill="none" viewBox="0 0 24 24"
            stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M8 10h.01M12 10h.01M16 10h.01M21 12c0 4.418-4.03 8-9 8s-9-3.582-9-8 4.03-8 9-8 9 3.582 9 8z" />
          </svg>
        </div>
        <h2 class="text-3xl font-bold text-primary-700 mb-2">Bienvenido, Asesor</h2>
        <p class="mb-4 text-text-400 text-center max-w-md">
          Para comenzar a atender a los clientes, haz clic en el botón para conectarte al chat en línea.<br>
          <span class="text-xs text-primary-400 block mt-2">Recuerda mantenerte disponible durante tu turno.</span>
        </p>
        <button
          class="btn btn-primary px-8 py-3 text-lg font-semibold rounded-full shadow-lg hover:bg-primary-600 transition"
          @click="connectSupport">
          <span class="flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M13 16h-1v-4h-1m4 0h-1v4h-1m-4 0h-1v-4h-1" />
            </svg>
            Conectarme como soporte
          </span>
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

const chatStore = useChatStore();
const authStore = useAuthStore();

interface Chat {
  id: string;
  name: string;
  online: boolean;
  time: string;
  messages: any[];
}

const chats = ref<Chat[]>([]);

const selectedChatId = ref<string | null>(null);
const selectChat = (id: string) => selectedChatId.value = id;

const selectedChat = computed(() =>
  chats.value.find(chat => chat.id === selectedChatId.value) || null
);

const selectedChatMessages = computed(() => {
  if (!selectedChat.value) return [];
  return chatStore.messages[selectedChat.value.id] || [];
});

const connected = ref(false);
const connectionStatus = computed(() => chatStore.connectionStatus);


const userId = authStore.getUserId;
const role = authStore.getRol;

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
  });

  onSocketReconnecting(() => {
    chatStore.setConnectionStatus("reconnecting");
  });

  onSocketError(() => {
    chatStore.setConnectionStatus("offline");
  });

  // El resto igual...
  onEmpresaAsignada((data) => {
    addOrUpdateChat(data.empresaId, data.room, data.nombreEmpresa);
  });

  onEmpresasAsignadas((empresas) => {
    empresas.forEach(e => addOrUpdateChat(e.empresaId, e.room, e.nombreEmpresa));
  });

  onEmpresaStatus((data) => {
    const chat = chats.value.find(c => c.id === data.empresaId);
    if (chat) chat.online = data.online;
  });

  onMessage(({ from, message, room }) => {
    const chatId = Object.keys(chatStore.rooms).find(key => chatStore.rooms[key] === room);
    if (!chatId) return;
    const fromType = from === userId ? "agent" : "user";
    chatStore.addMessageToChat(chatId, message, fromType);
    const chat = chats.value.find(c => c.id === chatId);
    if (chat) {
      chat.time = new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
    }
  });
}



function handleDisconnect() {
  disconnectChat();
  connected.value = false;
  selectedChatId.value = null;
  chats.value = [];
  chatStore.clearMessages();
  chatStore.setRoom("", "");
  connected.value = false;
  chatStore.setConnectionStatus('offline');
}

function onFinalizedChat(chatId: string) {
  // Eliminar el chat de la lista
  chats.value = chats.value.filter(c => c.id !== chatId);

  // Limpiar mensajes del store
  chatStore.clearMessages(chatId);

  // Borrar el room del store
  chatStore.setRoom(chatId, "");

  // Si el chat eliminado era el seleccionado, deseleccionarlo
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
      time: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
      messages: []
    };
    chats.value.push(chat);
    console.log("[FRONT] Chat agregado:", chat);
    if (!selectedChatId.value) selectedChatId.value = empresaId;
  }

  // Registrar room en el store
  chatStore.setRoom(empresaId, room);

  if (selectedChatId.value === empresaId) {
    chatStore.setRoom(empresaId, room);
  }

  console.log("[FRONT] Estado actual de chats:", chats.value);
}
defineOptions({ name: 'ClientsChatSection' });
</script>
