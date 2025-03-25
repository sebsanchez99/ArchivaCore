<template>
    <button
      :class="[
        'font-semibold px-6 py-3 rounded-lg transition cursor-pointer',
        primary
          ? 'bg-primary-500 text-white hover:bg-primary-800'
          : 'border text-gray-700 hover:bg-primary-100'
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
  