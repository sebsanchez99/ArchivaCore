<template>
  <section class="flex flex-col items-center text-center py-20 px-6 bg-white">
    <h1 class="text-5xl md:text-6xl font-bold tracking-tight mb-6 text-primary-800">
      Gestión de Archivos <span class="text-accent-500">Simplificada</span>
    </h1>

    <p class="max-w-3xl text-text-600 font-extralight text-lg md:text-xl mb-8">
      ArchivaCore es la solución integral para la gestión, almacenamiento y recuperación
      de documentos empresariales. Optimice sus procesos y mejore la productividad.
    </p>

    <div class="flex flex-col md:flex-row gap-4">
      <PrimaryButton primary label="Comenzar ahora">Comenzar Ahora</PrimaryButton>
      <PrimaryButton label="Ver planes">Ver Planes</PrimaryButton>
    </div>
  </section>
</template>

<script setup>
import PrimaryButton from '@/components/buttons/PrimaryButton.vue';
</script>
