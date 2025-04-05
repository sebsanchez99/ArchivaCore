<template>
    <div class="bg-primary-100 rounded-lg shadow-sm p-5">
      <h2 class="font-bold text-lg text-primary-700">Acceso rápido</h2>
      <p class="text-sm text-primary-600">Acciones frecuentes</p>
      <div class="mt-4 space-y-2 text-primary-600">
        <button class="btn btn-outline  border-primary-500 text-primary-700 btn-block justify-start gap-2 hover:bg-primary-200 sm: hover:shadow-2xl">
          <Cog8ToothIcon class="w-5" />
          Configuración de la cuenta
        </button>
        <button class="btn btn-outline  border-primary-500 text-primary-700 btn-block justify-start gap-2 hover:bg-primary-200 sm: hover:shadow-2xl">
          <ArrowDownOnSquareIcon class="w-5" />
          Descargar aplicación
        </button>
        <button class="btn btn-outline  border-primary-500 text-primary-700 btn-block justify-start gap-2 hover:bg-primary-200 sm: hover:shadow-2xl">
          <ChatBubbleLeftRightIcon class="w-5" />
          Contactar soporte
        </button>

      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { Cog8ToothIcon, ArrowDownOnSquareIcon, ChatBubbleLeftRightIcon } from "@heroicons/vue/24/outline";
  </script>
  