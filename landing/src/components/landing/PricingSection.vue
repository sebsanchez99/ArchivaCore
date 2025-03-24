<template>
    <div class="py-12 px-20">
        <h2 class="text-3xl font-bold text-center mb-10">Nuestros Planes</h2>
        <div class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Plan DEMO -->
      <div class="border rounded-lg p-6 shadow-sm flex flex-col">
        <h3 class="text-lg font-semibold text-center mb-2">DEMO</h3>
        <p class="text-3xl font-bold text-center mb-1">Gratis</p>
        <p class="text-center text-gray-500 mb-4">Por 14 días</p>
        <ul class="mb-6 space-y-2 text-gray-700">
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Almacenamiento de 5GB
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Hasta 3 usuarios
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Funciones básicas
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Soporte por email
          </li>
        </ul>
        <button class="cursor-pointer bg-primary-700 text-white rounded px-4 py-2 hover:bg-primary-900 mt-auto">
          Probar Gratis
        </button>
      </div>

      <!-- Plan ANUAL -->
      <div class="border rounded-lg p-6 shadow-md relative flex flex-col">
        <span class="absolute top-2 right-2 bg-blue-600 text-white text-xs font-semibold px-2 py-1 rounded-full">
          Recomendado
        </span>
        <h3 class="text-lg font-semibold text-center mb-2">ANUAL</h3>
        <p class="text-3xl font-bold text-center mb-1">$1000000</p>
        <p class="text-center text-gray-500 mb-4">Por empresa / año</p>
        <ul class="mb-6 space-y-2 text-gray-700">
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Almacenamiento ilimitado
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Usuarios ilimitados
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Todas las funciones avanzadas
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Soporte prioritario 24/7
          </li>
          <li class="flex items-center">
            <CheckCircleIcon class="w-5 h-5 text-blue-400 mr-2" />
            Integraciones personalizadas
          </li>
        </ul>
        <button class="cursor-pointer bg-primary-700 text-white rounded px-4 py-2 hover:bg-primary-900 mt-auto">
          Suscribirse
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { CheckCircleIcon } from '@heroicons/vue/24/solid'
</script>