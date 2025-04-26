<template>
  <div class="py-12 px-6 md:px-20 bg-white text-black">
    <h2 class="text-4xl font-bold text-center mb-10">Nuestros Planes</h2>
    <div class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-6">
      <PlanCard
        v-for="(plan, index) in plans"
        :key="index"
        v-bind="plan"
      />
    </div>
  </div>
</template>

<script setup>
import PlanCard from '@/modules/landing/components/PlanCard.vue';

const plans = [
  {
    title: 'DEMO',
    price: 'Gratis',
    description: 'Por 14 días',
    features: [
      'Almacenamiento de 5GB',
      'Hasta 3 usuarios',
      'Funciones básicas',
      'Soporte por email',
    ],
    recommended: false,
    color: 'bg-primary-100',
  },
  {
    title: 'ANUAL',
    price: '$1,000,000',
    description: 'Por empresa / año',
    features: [
      'Almacenamiento ilimitado',
      'Usuarios ilimitados',
      'Todas las funciones avanzadas',
      'Soporte prioritario 24/7',
      'Integraciones personalizadas',
    ],

    recommended: true,
    color: 'bg-secondary-100',
  },
];
</script>
