<template>
  <div>
    <!-- Campo de búsqueda -->
    <div class="mb-7 input bg-white">
      <MagnifyingGlassIcon class="w-5 text-gray-500" />
      <input v-model="search" type="text" class="w-full" placeholder="Buscar por nombre..." />
    </div>

    <!-- Lista de chats -->
    <ul class="space-y-3">
      <li v-for="chat in filteredChats" :key="chat.id" @click="emit('selectChat', chat.id)"
        class="p-3 rounded-lg bg-white shadow hover:bg-primary-100 cursor-pointer transition-all" :class="[
          'p-3 rounded-lg bg-white shadow hover:bg-primary-100 cursor-pointer transition-all',
          chat.id === selectedChatId ? 'border-2 border-primary-500' : '',
          chatStore.unreadMessages[chat.id] ? 'ring-2 ring-blue-500 ' : ''
        ]">
        <!-- Contenedor de fila -->
        <div class="flex items-center justify-between gap-2">
          <!-- Info del cliente -->
          <div class="flex items-center gap-3 flex-1 min-w-0">
            <!-- Estado -->
            <span class="w-3 h-3 rounded-full shrink-0" :class="chat.online ? 'bg-green-500' : 'bg-gray-400'"></span>
            <!-- Textos -->
            <div class="flex-1 min-w-0">
              <!-- Nombre + icono de campana -->
              <div class="flex items-center gap-1">
                <p class="font-semibold truncate">
                  {{ chat.name }}
                </p>
                <BellIcon v-if="chatStore.unreadMessages[chat.id]"
                  class="w-4 h-4 text-blue-500 animate-bounce shrink-0" />
              </div>

              <p class="text-xs text-gray-500 truncate">
                {{ chat.online ? 'En línea' : 'Desconectado' }}
              </p>
              <p v-if="lastMessage(chat.id)" class="text-xs text-gray-400 truncate">
                {{ lastMessage(chat.id) }}
              </p>
            </div>
          </div>
          <!-- Hora -->
          <span class="text-xs text-gray-400 whitespace-nowrap shrink-0">{{ chat.time }}</span>
        </div>
      </li>

    </ul>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { MagnifyingGlassIcon } from "@heroicons/vue/24/outline"
import { useChatStore } from "@/stores/chatStore";
import { BellIcon } from "@heroicons/vue/24/solid"

const chatStore = useChatStore();

const props = defineProps<{
  chats: { id: string, name: string, online: boolean, time: string }[],
  selectedChatId: string | null
}>()

const emit = defineEmits(['selectChat'])

const search = ref('')

const filteredChats = computed(() =>
  props.chats.filter(chat =>
    chat.name.toLowerCase().includes(search.value.toLowerCase())
  )
)

function lastMessage(chatId: string): string | null {
  const msgs = chatStore.messages[chatId];
  if (!msgs || msgs.length === 0) return null;
  return msgs[msgs.length - 1].text;
}

</script>