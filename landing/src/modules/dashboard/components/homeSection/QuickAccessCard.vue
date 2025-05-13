<template>
    <div class="bg-secondary-50 rounded-lg shadow-sm p-5">
      <h2 class="font-semibold text-lg text-text-500">Acceso rápido</h2>
      <p class="text-sm text-text-500">Acciones frecuentes</p>
      <div class="mt-4 space-y-2 text-primary-600">
        <button class="btn btn-outline border-none bg-primary-500 text-white btn-block justify-start gap-2 hover:bg-primary-600 sm: hover:shadow-2xl">
          <Cog8ToothIcon class="w-5" />
          Configuración de la cuenta
        </button>
        <button class="btn btn-outline border-none  bg-primary-500 text-white btn-block justify-start gap-2 hover:bg-primary-600 sm: hover:shadow-2xl">
          <ArrowDownOnSquareIcon class="w-5" />
          Descargar aplicación
        </button>
        <button class="btn btn-outline border-none bg-primary-500 text-white btn-block justify-start gap-2 hover:bg-primary-600 sm: hover:shadow-2xl">
          <ChatBubbleLeftRightIcon class="w-5" />
          Contactar soporte
        </button>

      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { Cog8ToothIcon, ArrowDownOnSquareIcon, ChatBubbleLeftRightIcon } from "@heroicons/vue/24/outline";
  </script>
  