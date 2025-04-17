<template>
    <div class="max-w-6xl mx-auto px-4 py-6">
        <div class="grid grid-cols-12 gap-4 h-[85vh]">
            <div class="col-span-4 bg-primary-200 rounded-lg shadow p-4 overflow-y-auto ">
                <ChatListPanel :chats="chats" :selectedChatId="selectedChatId" @selectChat="selectChat" />
            </div>

            <!-- Chat seleccionado (columna derecha) -->
            <div class="col-span-8 bg-white rounded-lg shadow p-4 flex flex-col">
                <ChatDetails :chat="selectedChat" />

            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, computed } from 'vue'
import ChatListPanel from "@/modules/dashboard/components/ClientsChatSection/ChatListPanel.vue";
import ChatDetails from "@/modules/dashboard/components/ClientsChatSection/ChatDetails.vue";
const chats = ref([
  {
    id: 1,
    name: 'Empresa A',
    online: true,
    time: '2m',
    messages: [
      { text: 'Hola, necesito ayuda con mi cuenta.', time: '10:12 AM', from: 'user' as const }
    ]
  },
  {
    id: 2,
    name: 'Empresa B',
    online: false,
    time: '15m',
    messages: [
      { text: '¿Cómo puedo cambiar mi correo?', time: '9:58 AM', from: 'user' as const }
    ]
  },
  {
    id: 3,
    name: 'Empresa C',
    online: true,
    time: '5m',
    messages: [
      { text: 'Tengo problemas para iniciar sesión.', time: '10:30 AM', from: 'user' as const }
    ]
  }
])


const selectedChatId = ref<number | null>(null)
const selectChat = (id: number) => selectedChatId.value = id

const selectedChat = computed(() =>
    chats.value.find(chat => chat.id === selectedChatId.value) || null
)
</script>