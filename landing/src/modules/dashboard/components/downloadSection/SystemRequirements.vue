<template>
    <div>
      <h4 class="text-md font-semibold text-text-500 mb-2">Requisitos del sistema</h4>
      <div class="bg-secondary-100 rounded-md p-4 text-sm text-text-800">
        <ul class="list-disc pl-4 space-y-1">
          <li v-for="(req, i) in requirements" :key="i">{{ req }}</li>
        </ul>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  defineProps<{
    requirements: string[];
  }>();
  </script>
  