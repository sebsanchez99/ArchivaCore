<template>
    <div class="alert bg-primary-100 border border-primary-200 shadow text-primary-700">
      <InformationCircleIcon class="w-6 text-primary-500" />
      <span>
        <strong>Su cuento DEMO expirará en 7 días</strong><br />
        Actualice a la versión PRO para disfrutar de todas las funcionalidades de la plataforma.
      </span>
      <div class="ml-auto">
        <button class="btn bg-primary-500 border-none hover:bg-primary-400">Actualizar ahora</button>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { InformationCircleIcon } from "@heroicons/vue/24/outline";
  </script>
  