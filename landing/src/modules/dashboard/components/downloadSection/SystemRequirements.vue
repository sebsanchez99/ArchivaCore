<template>
    <div>
      <h4 class="text-md font-semibold text-primary-800 mb-2">Requisitos del sistema</h4>
      <div class="border border-primary-300 bg-white rounded-md p-4 text-sm text-primary-800">
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
  