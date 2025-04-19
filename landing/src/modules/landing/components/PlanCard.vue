<template>
    <div :class="`${color} rounded-lg p-6 relative flex flex-col`">
      <!-- Etiqueta "Recomendado" opcional -->
      <span
        v-if="recommended"
        class="absolute top-2 right-2 bg-primary-600 text-white text-xs font-semibold px-2 py-1 rounded-full"
      >
        Recomendado
      </span>
  
      <h3 class="text-lg font-semibold text-center mb-2">{{ title }}</h3>
      <p class="text-3xl font-bold text-center mb-1">{{ price }}</p>
      <p class="text-center text-gray-500 mb-4">{{ description }}</p>
  
      <ul class="mb-6 space-y-2 text-gray-700">
        <li v-for="(feature, index) in features" :key="index" class="flex items-center">
          <CheckCircleIcon class="w-5 h-5 text-secondary-400 mr-2" aria-hidden="true" />
          {{ feature }}
        </li>
      </ul>
  
      <button class="bg-primary-500 text-white rounded px-4 py-2 hover:bg-primary-600 mt-auto cursor-pointer">
        {{ buttonText }}
      </button>
    </div>
  </template>
  
  <script setup>
  import { CheckCircleIcon } from '@heroicons/vue/24/solid';
  
  defineProps({
    title: String,        
    price: String,        
    description: String,  
    features: Array,      
    buttonText: String,   
    recommended: Boolean, 
    color: String,
  });
  </script>
  