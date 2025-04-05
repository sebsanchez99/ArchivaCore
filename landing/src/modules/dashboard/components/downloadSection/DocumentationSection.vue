<template>
    <div class="bg-primary-50 border border-primary-100 rounded-xl p-6 mt-10 shadow-sm">
      <h3 class="text-lg font-semibold text-primary-700 mb-1">Documentación</h3>
      <p class="text-sm text-primary-600 mb-4">Manuales y guías de usuario</p>
      <p class="text-primary-700 text-sm mb-4">
        Descargue nuestro manual de usuario para obtener instrucciones detalladas sobre cómo instalar y utilizar ArchivaCore.
      </p>
      <button class="btn btn-outline justify-start gap-2 border-primary-500 text-primary-700 hover:bg-primary-100 text-sm w-full sm:w-auto hover:shadow-2xl">
        <DocumentIcon class="w-4"/>
        Manual de Usuario (PDF)
      </button>
    </div>
  </template>
  
  <script setup lang="ts">
  import { DocumentIcon } from '@heroicons/vue/24/outline';
  </script>
  