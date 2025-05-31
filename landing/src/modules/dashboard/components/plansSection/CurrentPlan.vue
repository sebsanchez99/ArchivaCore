<!-- filepath: c:\dev\ArchivaCore\landing\src\modules\dashboard\components\CurrentPlan.vue -->
<template>
  <div class="bg-primary-50 border border-primary-100 rounded-xl shadow-sm p-6">
    <div class="flex justify-between items-center">
      <h3 class="text-xl font-semibold text-text-800">Plan actual</h3>
      <span class="badge badge-outline font-semibold border border-secondary-500 text-secondary-500">
        {{ currentPlan.shortName }}
      </span>
    </div>
    <p class="text-sm text-text-400 mb-6 border-b border-primary-500 pb-4">
      Detalles de tu suscripción actual
    </p>
    <div class="grid md:grid-cols-2 gap-6 px-2">
      <div class="border-r border-primary-500 pr-4">
        <h4 class="text-xl font-semibold text-text-600 mb-2">{{ currentPlan.name }}</h4>
        <p class="text-sm text-text-400 mb-4">{{ currentPlan.description }}</p>
        <ul class="space-y-3 text-sm text-text-400">
          <li v-for="(feature, index) in currentPlan.features" :key="index" class="flex items-center gap-3">
            <span class="bg-white rounded-full p-1 shadow-sm">
              <CheckCircleIcon class="w-5 text-accent-500" />
            </span>
            <p>{{ feature }}</p>
          </li>
        </ul>
        <button class="w-full btn mt-4 bg-primary-500 text-white hover:bg-primary-600 border-none" @click="scrollToPayment">
          Cambiar plan
        </button>
        <button class="w-full btn mt-2 bg-red-500 text-white hover:bg-red-600 border-none">
          Cancelar plan
        </button>
      </div>
      <FAQSection />
    </div>
  </div>
</template>

<script lang="ts" setup>
import { CheckCircleIcon } from "@heroicons/vue/24/outline";
import FAQSection from "./FAQSection.vue";
defineProps(["currentPlan", "scrollToPayment"]);
</script>