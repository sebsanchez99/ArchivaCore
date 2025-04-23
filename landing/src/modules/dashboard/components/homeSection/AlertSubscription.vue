<template>
    <div class="alert bg-secondary-100 border-none shadow text-text-500">
      <InformationCircleIcon class="w-6 text-primary-500" />
      <span>
        <p class="font-semibold">Su cuento DEMO expirará en 7 días</p>
        <p class="text-text-400">Actualice a la versión PRO para disfrutar de todas las funcionalidades de la plataforma.</p>
      </span>
      <div class="ml-auto">
        <button class="btn bg-primary-500 border-none hover:bg-primary-600 text-white">Actualizar ahora</button>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { InformationCircleIcon } from "@heroicons/vue/24/outline";
  </script>
  