<template>
    <div class="bg-secondary-50 rounded-xl p-6 mt-10 shadow-sm">
      <h3 class="text-lg font-semibold text-text-500 mb-1">Documentación</h3>
      <p class="text-sm text-text-400 mb-4">Manuales y guías de usuario</p>
      <p class="text-text-400 text-sm mb-4">
        Descargue nuestro manual de usuario para obtener instrucciones detalladas sobre cómo instalar y utilizar ArchivaCore.
      </p>
      <button class="btn justify-start gap-2 border-none text-white bg-primary-500 hover:bg-primary-600 text-sm w-full sm:w-auto hover:shadow-2xl">
        <DocumentIcon class="w-4"/>
        Manual de Usuario (PDF)
      </button>
    </div>
  </template>
  
  <script setup lang="ts">
  import { DocumentIcon } from '@heroicons/vue/24/outline';
  </script>
  