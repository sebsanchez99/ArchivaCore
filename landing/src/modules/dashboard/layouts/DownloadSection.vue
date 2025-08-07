<template>
    <div class="max-w-7xl mx-auto">
      <SectionHeader title="Descargar ArchivaCore" subtitle="Obtenga la aplicación de escritorio para una experiencia completa"/>
  
      <div class="bg-primary-50 border border-primary-100 rounded-xl shadow-sm p-6">
        <h3 class="text-xl font-semibold text-text-800 mb-1">Aplicación de Escritorio</h3>
        <p class=" badge bg-secondary-100 border-none text-sm text-text-400 mb-4">Versión 1.0.0</p>
  
        <p class="text-text-700 mb-6 border-b border-primary-500 pb-4 text-sm sm:text-base">
          ArchivaCore le permite gestionar su información de recursos humanos de forma ágil y centralizada directamente
          desde su computador. Acceda a todos los módulos del sistema con una experiencia optimizada para escritorio,
          manteniendo una conexión segura con el servidor.
        </p>
  
        <div class="grid md:grid-cols-2 gap-6 mb-6">
          <FeaturesList :features="features" />
          <SystemRequirements :requirements="requirements" />
        </div>
  
        <div class="flex justify-center">
          <DownloadButton label="Descargar para Windows (64 bits)" />
        </div>
      </div>
  
      <DocumentationSection />
    </div>
  </template>
  
  <script setup lang="ts">
  import SectionHeader from '@/modules/dashboard/components/downloadSection/SectionHeader.vue';
  import FeaturesList from '@/modules/dashboard/components/downloadSection/FeaturesList.vue';
  import SystemRequirements from '@/modules/dashboard/components/downloadSection/SystemRequirements.vue';
  import DownloadButton from '@/modules/dashboard/components/downloadSection/DownloadButton.vue';
  import DocumentationSection from '@/modules/dashboard/components/downloadSection/DocumentationSection.vue';
  
  const features = [
    {
      title: 'Gestión completa de recursos humanos',
      description: 'Administre usuarios, documentos, roles y notificaciones de manera eficiente y segura.',
    },
    {
      title: 'Inteligencia artificial para selección',
      description: 'Analiza hojas de vida y evalúa su idoneidad frente a una oferta laboral con explicaciones automáticas.',
    },
    {
      title: 'Automatización de carpetas y archivos',
      description: 'Organiza documentos y expedientes de manera automática según reglas personalizadas.',
    },
    {
      title: 'Integración con la nube',
      description: 'Acceso en tiempo real y respaldo seguro a través de conexión con el servidor.',
    },
  ];
  
  const requirements = [
    'Windows 10 o superior (64-bit)',
    '4 GB de RAM o más',
    '500 MB de espacio en disco disponible',
    'Conexión a Internet para actualizaciones y soporte',
  ];
  </script>
  