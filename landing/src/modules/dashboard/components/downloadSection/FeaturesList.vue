<template>
    <ul class="space-y-4 text-sm text-primary-800">
      <li v-for="(feature, index) in features" :key="index" class="flex items-start gap-3 transition-all duration-200 hover:scale-[1.01]">
        <span class="bg-white rounded-full p-1 shadow-sm">
          <CheckCircleIcon class="h-5 w-5 text-primary-500" />
        </span>
        <div>
          <strong>{{ feature.title }}</strong><br />
          {{ feature.description }}
        </div>
      </li>
    </ul>
  </template>
  
  <script setup lang="ts">
  import { CheckCircleIcon } from '@heroicons/vue/24/outline';
  
  defineProps<{
    features: { title: string; description: string }[];
  }>();
  </script>
  