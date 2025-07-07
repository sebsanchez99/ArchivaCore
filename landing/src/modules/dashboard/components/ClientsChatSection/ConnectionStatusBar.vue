<template>
  <div
    :class="`w-full border-b px-4 py-2 flex items-center justify-between text-sm font-medium rounded-md shadow-sm ${backgroundClass}`">
    <div class="flex items-center gap-2">
      <span class="font-semibold text-primary-600">👨‍💼 {{ username }}</span>
      <span class="text-gray-400">|</span>
      <span class="flex items-center gap-1" :class="statusClass">
        <span class="w-2 h-2 rounded-full" :class="dotClass"></span>
        {{ statusText }}
      </span>
    </div>
    <button
      class="flex items-center gap-2 btn btn-sm bg-red-500 hover:bg-red-600 text-white font-semibold px-5 py-2 border-none "
      @click="handleDisconnect">
      <PowerIcon class="w-4 text-white mr-1" />
      Finalizar sesión
    </button>
  </div>
</template>

<script lang="ts" setup>
import { computed } from 'vue';
import { useAuthStore } from '@/stores/authStore';
import { disconnectChat } from "@/services/chatService";
import { PowerIcon } from "@heroicons/vue/24/outline";

const props = defineProps<{
  connectionStatus: 'offline' | 'connecting' | 'online' | 'reconnecting';
}>();

const emit = defineEmits(['disconnect']);

const authStore = useAuthStore();
const username = computed(() => authStore.getFullname || 'Asesor');

const statusText = computed(() => {
  switch (props.connectionStatus) {
    case 'connecting':
      return 'Conectando...';
    case 'reconnecting':
      return 'Reconectando...';
    case 'offline':
      return 'Conexión perdida';
    case 'online':
      return 'Conectado';
    default:
      return '';
  }
});

const statusClass = computed(() => {
  switch (props.connectionStatus) {
    case 'online':
      return 'text-green-600';
    case 'reconnecting':
    case 'connecting':
      return 'text-yellow-600';
    case 'offline':
      return 'text-red-600';
    default:
      return 'text-gray-600';
  }
});

const dotClass = computed(() => {
  switch (props.connectionStatus) {
    case 'online':
      return 'bg-green-500';
    case 'connecting':
    case 'reconnecting':
      return 'bg-yellow-500 animate-pulse';
    case 'offline':
      return 'bg-red-500';
    default:
      return 'bg-gray-400';
  }
});

const backgroundClass = computed(() => {
  switch (props.connectionStatus) {
    case 'online':
      return 'bg-green-50 border-green-200';
    case 'connecting':
    case 'reconnecting':
      return 'bg-yellow-50 border-yellow-200';
    case 'offline':
      return 'bg-red-50 border-red-200';
    default:
      return 'bg-gray-100 border-gray-300';
  }
});

function handleDisconnect() {
  disconnectChat();
  emit('disconnect');
}
</script>
