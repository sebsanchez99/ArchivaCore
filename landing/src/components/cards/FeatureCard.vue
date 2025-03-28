<template>
  <div class="bg-white rounded-lg p-6 text-center shadow-sm w-full md:w-5/12 lg:w-1/4">
    <component :is="iconComponent" class="mx-auto mb-4 text-blue-400 w-10 h-10" aria-hidden="true" />
    <h3 class="text-xl font-semibold mb-2 text-black">{{ title }}</h3>
    <p class="text-gray-500">{{ description }}</p>
  </div>
</template>

<script setup>
import { h, computed } from 'vue';

const props = defineProps({
  icon: [Function, Object], 
  title: String,
  description: String,
});

const iconComponent = computed(() => {
  return typeof props.icon === 'function' ? h(props.icon) : props.icon;
});
</script>
