<template>
    <section class="bg-primary-200 py-12 px-6 md:px-20">
      <h2 class="text-4xl font-bold text-center mb-10 text-black">Características Principales</h2>
      <div class="flex flex-col md:flex-row md:flex-wrap justify-center gap-6">
        <FeatureCard
          :icon="ServerStackIcon"
          title="Almacenamiento Seguro"
          description="Guarde sus documentos con la máxima seguridad y acceda a ellos desde cualquier lugar."
        />
        <FeatureCard
          :icon="FolderIcon"
          title="Organización Inteligente"
          description="Clasifique automáticamente sus archivos con nuestro sistema de etiquetado inteligente."
        />
        <FeatureCard
          :icon="LockClosedIcon"
          title="Control de Acceso"
          description="Gestione permisos y controle quién puede ver, editar o compartir sus documentos."
        />
        <FeatureCard
          :icon="CpuChipIcon"
          title="Análisis Inteligente de Hojas de Vida"
          description="Nuestra IA analiza, clasifica y resume hojas de vida para facilitar decisiones de contratación más rápidas y efectivas."
        />
      </div>
    </section>
  </template>
  
  <script setup>
  import { FolderIcon, LockClosedIcon, CpuChipIcon, ServerStackIcon } from '@heroicons/vue/24/outline';
  import FeatureCard from '@/components/cards/FeatureCard.vue';
  </script>
  