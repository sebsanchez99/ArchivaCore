<template>
  <div class="bg-secondary-50 rounded-xl p-6 mt-10 shadow-sm">
    <h3 class="text-lg font-semibold text-text-500 mb-1">Documentación</h3>
    <p class="text-sm text-text-400 mb-4">Manuales y guías de usuario</p>
    <p class="text-text-400 text-sm mb-4">
      Descargue nuestro manual de usuario para obtener instrucciones detalladas sobre cómo instalar y utilizar
      ArchivaCore.
    </p>
    <DownloadButton label="Manual de Usuario (PDF)" file="files/manualprueba.pdf" fileName="Manual_ArchivaCore.pdf">
      <DocumentIcon class="w-4" />
    </DownloadButton>
  </div>
</template>

<script setup lang="ts">
import { DocumentIcon } from '@heroicons/vue/24/outline';
import DownloadButton from '@/modules/dashboard/components/downloadSection/DownloadButton.vue'
</script>