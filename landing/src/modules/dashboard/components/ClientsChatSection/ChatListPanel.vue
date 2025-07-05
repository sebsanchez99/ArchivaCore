<template>
  <div class="flex justify-end mb-6">
    <button
      class="flex items-center gap-2 btn bg-red-500 hover:bg-red-600 text-white font-semibold px-5 py-2 rounded-full shadow transition"
      @click="handleDisconnect"
    >
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
      Desconectarme
    </button>
  </div>
  <div>
    <!-- Campo de búsqueda -->
    <div class="mb-7 input bg-white">
      <MagnifyingGlassIcon class="w-5 text-gray-500" />
      <input
        v-model="search"
        type="text"
        class="w-full"
        placeholder="Buscar por nombre..."
      />
    </div>

    <!-- Lista de chats -->
    <ul class="space-y-3">
      <li
        v-for="chat in filteredChats"
        :key="chat.id"
        @click="emit('selectChat', chat.id)"
        class="p-3 rounded-lg bg-white shadow hover:bg-primary-100 cursor-pointer flex justify-between items-center"
        :class="{ 'border-2 border-primary-500': chat.id === selectedChatId }"
      >
        <div class="flex items-center gap-3">
          <!-- Estado -->
          <span
            class="w-3 h-3 rounded-full"
            :class="chat.online ? 'bg-green-500' : 'bg-gray-400'"
          ></span>

          <!-- Info del cliente -->
          <div>
            <p class="font-semibold">{{ chat.name }}</p>
            <p class="text-xs text-gray-500">{{ chat.online ? 'En línea' : 'Desconectado' }}</p>
          </div>
        </div>

        <!-- Hora -->
        <span class="text-xs text-gray-400 whitespace-nowrap">{{ chat.time }}</span>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { MagnifyingGlassIcon } from "@heroicons/vue/24/outline"
import { disconnectChat } from "@/services/chatService";

const props = defineProps<{
  chats: { id: string, name: string, online: boolean, time: string }[],
  selectedChatId: string | null
}>()

const emit = defineEmits(['selectChat', 'disconnect'])

const search = ref('')

const filteredChats = computed(() =>
  props.chats.filter(chat =>
    chat.name.toLowerCase().includes(search.value.toLowerCase())
  )
)

function handleDisconnect() {
  disconnectChat();
  emit('disconnect');
}
</script>