<template>
  <div class="bg-primary-100 rounded-lg shadow-sm p-5 min-h-[180px] flex flex-col justify-center items-center" v-if="loading">
    <svg class="animate-spin h-8 w-8 text-secondary-500 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
    </svg>
    <span class="text-secondary-500 font-semibold">Cargando almacenamiento...</span>
  </div>
  <div v-else class="bg-primary-100 rounded-lg shadow-sm p-5">
    <h2 class="font-semibold text-lg text-text-500">Almacenamiento</h2>
    <p class="text-sm text-text-500">Espacio consumido</p>
    <div class="mt-2 text-sm font-semibold text-text-400">
      {{ props.storage?.totalGB || 0 }} GB de 5 GB consumidos
      <span class="float-right">{{ percentUsed }}%</span>
    </div>
    <progress class="progress text-secondary-500 w-full mt-1" :value="percentUsed" max="100"></progress>
    <div v-if="percentUsed >= 100" class="mt-2 text-red-600 text-sm font-semibold text-center">
      ¡Has alcanzado el límite de almacenamiento!
    </div>
    <div class="mt-4 flex justify-between text-center text-sm">
      <div v-for="(value, key) in props.storage?.categories || {}" :key="key">
        <div class="font-semibold text-text-700">{{ value }} MB</div>
        <div class="text-text-300">{{ capitalize(key) }}</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, toRefs } from "vue";
import { useHomeStore } from "@/stores/homeStore";

const props = defineProps<{
  storage: {
    totalMB: string;
    totalGB: string;
    categories: Record<string, string>;
  } | null;
}>();

const homeStore = useHomeStore();
const { loading } = toRefs(homeStore);

const percentUsed = computed(() => {
  if (!props.storage) return 0;
  const used = parseFloat(props.storage.totalMB);
  const max = 5000; // 5 GB en MB
  return Math.min(100, Number(((used / max) * 100).toFixed(0)));
});

function capitalize(str: string) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}
</script>