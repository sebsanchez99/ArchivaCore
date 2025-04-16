<!-- filepath: c:\dev\ArchivaCore\landing\src\modules\dashboard\components\CurrentPlan.vue -->
<template>
  <div class="bg-primary-50 border border-primary-100 rounded-xl shadow-sm p-6">
    <div class="flex justify-between items-center">
      <h3 class="text-xl font-semibold text-primary-800">Plan actual</h3>
      <span class="badge badge-outline font-semibold border border-primary-500 text-primary-500">
        {{ currentPlan.shortName }}
      </span>
    </div>
    <p class="text-sm text-primary-600 mb-6 border-b border-primary-300 pb-4">
      Detalles de tu suscripción actual
    </p>
    <div class="grid md:grid-cols-2 gap-6 px-2">
      <div class="border-r border-primary-300 pr-4">
        <h4 class="text-xl font-bold text-primary-600 mb-2">{{ currentPlan.name }}</h4>
        <p class="text-sm text-primary-600 mb-4">{{ currentPlan.description }}</p>
        <ul class="space-y-3 text-sm text-primary-800">
          <li v-for="(feature, index) in currentPlan.features" :key="index" class="flex items-center gap-3">
            <span class="bg-white rounded-full p-1 shadow-sm">
              <CheckCircleIcon class="w-5 text-green-500" />
            </span>
            <p>{{ feature }}</p>
          </li>
        </ul>
        <button class="w-full btn mt-4 bg-primary-500 text-white hover:bg-primary-400 border-none" @click="scrollToPayment">
          Cambiar plan
        </button>
        <button class="w-full btn mt-2 bg-red-500 text-white hover:bg-red-400 border-none">
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