<template>
    <div class="flex-1 flex flex-col h-full">
        <div v-if="!chat" class="flex flex-col items-center justify-center flex-1 text-center text-text-500">
            <div class="avatar mb-4">
                <div class="w-20 rounded-full bg-primary-100 p-4">
                    <ChatBubbleBottomCenterTextIcon class="text-primary-600 w-12 h-12" />
                </div>
            </div>
            <h3 class="text-xl font-semibold">Selecciona un chat</h3>
            <p class="text-sm text-text-400">Aquí podrás ver y responder mensajes de los clientes</p>
        </div>

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
                    <PowerIcon class="w-4 text-white mr-1" />
                    Finalizar chat
                </button>
            </div>

            <!-- Mensajes -->
            <div ref="chatContainer" class="flex-1 overflow-y-auto py-4 space-y-4">
                <div v-for="(msg, index) in messages" :key="index" :class="getMessageClass(msg.from)">
                    <template v-if="msg.from === 'user'">
                        <!-- Avatar del cliente -->
                        <div class="chat-image avatar mr-2">
                            <div class="bg-accent-200 text-white rounded-full font-bold p-3 shadow">
                                {{ getInitials(chat.name) }}
                            </div>
                        </div>
                    </template>

                    <div>
                        <!-- Cabecera -->
                        <div class="chat-header text-xs text-primary-600 flex justify-between ml-2 font-semibold">
                            {{ msg.from === 'agent' ? 'Agente Soporte' : chat.name }}
                            <time class="ml-2">{{ msg.time }}</time>
                        </div>
                        <!-- Burbuja de mensaje -->
                        <div class="chat-bubble text-text-400 text-sm bg-primary-100">
                            {{ msg.text }}
                        </div>
                    </div>
                </div>
            </div>


            <!-- Input -->
            <div class="pt-2 border-t border-primary-500 flex gap-2 items-center">
                <input v-model="input" @keyup.enter="sendMessage" type="text" placeholder="Escribe un mensaje..."
                    class="input w-full bg-white border border-primary-500" />
                <button @click="sendMessage" class="btn btn-primary bg-primary-500 border-none">
                    <PaperAirplaneIcon class="w-5" />
                </button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, onMounted, computed, onUnmounted } from "vue";
import {
    ChatBubbleBottomCenterTextIcon,
    PaperAirplaneIcon,
    PowerIcon
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

const props = defineProps<{ chat: any; messages: ChatMessage[] }>();
let systemHandler: (data: any) => void;
const emit = defineEmits(["chatFinalizado"]);

const chatStore = useChatStore();
const authStore = useAuthStore();

const input = ref("");
const chatContainer = ref<HTMLElement | null>(null);
const userId = authStore.getUserId;

// Obtiene el room asociado a este chat
const room = computed(() => chatStore.rooms[props.chat?.id]);

function sendMessage() {
    if (!input.value.trim() || !room.value || !props.chat) return;
    sendMessageToRoom(room.value, input.value, userId);
    input.value = "";
}

function endChat() {
    if (!props.chat || !room.value) return;

    // Emitir al WebSocket para cerrar el chat
    endChatService(props.chat.id, room.value);

    // Limpiar mensajes del store
    chatStore.clearMessages(props.chat.id);

    // Notificar al padre para que quite el chat de la lista
    emit("chatFinalizado", props.chat.id);

    // Limpiar input
    input.value = "";
}


function getInitials(name: string) {
    return name.trim().substring(0, 2).toUpperCase();
}

function getMessageClass(from: "user" | "agent" | "system") {
    if (from === "agent") return "chat chat-end";
    if (from === "system") return "chat chat-center";
    return "chat chat-start";
}

// Auto-scroll al recibir nuevos mensajes
watch(() => props.messages, async () => {
    await nextTick();
    if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
    }
});

// Escuchar solo los mensajes del room actual
onMounted(() => {
  systemHandler = (data) => {
    if (!props.chat) return;

    console.log("[FRONT] Mensaje del sistema recibido:", data);
    console.log(authStore.getRol);

    if (data.type === "agent-disconnect" && authStore.getRol === "Asesor") return;
    if (data.type === "user-disconnect" && authStore.getRol === "Empresa") return;

    chatStore.addMessageToChat(props.chat.id, data.message, "system");
  };

  onSystemMessage(systemHandler);
});

onUnmounted(() => {
  // Desuscribirse del evento al desmontar
  offSystemMessage(systemHandler);
});
</script>
