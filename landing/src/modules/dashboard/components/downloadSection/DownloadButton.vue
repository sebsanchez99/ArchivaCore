<template>
    <button class="btn btn-block bg-primary-500 hover:bg-primary-600 text-white font-semibold gap-2 border-none shadow-md">
      <ArrowDownTrayIcon class="w-5" />
      {{ label }}
    </button>
  </template>
  
  <script setup lang="ts">
  import { ArrowDownTrayIcon } from '@heroicons/vue/24/outline';
  
  defineProps<{
    label: string;
  }>();
  </script>
  