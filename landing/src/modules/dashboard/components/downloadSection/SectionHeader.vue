<template>
    <div>
      <h2 class="text-2xl font-bold text-primary-800 mb-1">{{ title }}</h2>
      <p class="text-sm text-primary-600 mb-6">{{ subtitle }}</p>
    </div>
  </template>
  
  <script setup lang="ts">
  defineProps<{
    title: string;
    subtitle: string;
  }>();
  </script>
  