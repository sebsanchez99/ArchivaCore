<template>
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
</script>