<template>
    <button
      :class="[
        'cursor-pointer px-4 py-1.5 rounded text-sm font-semibold transition',
        primary
          ? 'bg-primary-500 text-white hover:bg-primary-700'
          : 'border border-black hover:bg-primary-100'
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
  