<template>
    <button
      :class="[
        'font-semibold px-6 py-3 rounded-lg transition cursor-pointer',
        primary
          ? 'bg-primary-500 text-white hover:bg-primary-700'
          : 'bg-secondary-300 text-white hover:bg-secondary-400'
      ]"
      :aria-label="label"
    >
      <slot />
    </button>
  </template>
  
  <script setup>
  defineProps({
    primary: Boolean, 
    label: String, 
  });
  </script>
  