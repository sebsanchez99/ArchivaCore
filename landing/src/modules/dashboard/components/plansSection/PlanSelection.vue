<!-- filepath: c:\dev\ArchivaCore\landing\src\modules\dashboard\components\plansSection\PlanSelection.vue -->
<template>
  <div class="border rounded-xl border-primary-400 p-6">
    <h2 class="text-xl font-semibold mb-2 text-text-500">Selecciona un plan</h2>
    <div class="space-y-4">
      <label
        v-for="(plan, index) in plans"
        :key="index"
        class="flex justify-between items-center border p-4 rounded-lg shadow-sm cursor-pointer transition-all duration-200"
        :class="modelValue === plan.name ? 'bg-primary-100 border-primary-100' : 'hover:shadow-md border-gray-300'"
      >
        <div class="flex items-center gap-4">
          <input
            type="radio"
            name="plan"
            class="radio radio-primary text-primary-500 border-primary-500 checked:bg-white"
            :value="plan.name"
            :checked="modelValue === plan.name"
            @change="$emit('update:modelValue', plan.name)"
          />
          <div>
            <h3 class="text-md font-semibold text-text-400">{{ plan.name }}</h3>
            <p class="text-sm text-text-400">{{ plan.description }}</p>
            <ul class="mt-2 text-sm text-gray-700 space-y-1">
              <li v-for="(feature, i) in plan.features" :key="i" class="flex gap-2">
                <span class="bg-white rounded-full p-1 shadow-sm">
                  <CheckCircleIcon class="w-5 text-secondary-500" />
                </span>
                <span>{{ feature }}</span>
              </li>
            </ul>
          </div>
        </div>
        <div class="text-lg font-semibold text-text-400">
          {{ plan.price }}
        </div>
      </label>
    </div>
    <div class="flex justify-end mt-6 gap-3">
      <button class="btn border-none text-white bg-red-500 hover:bg-red-600" @click="scrollToPlans">
        Cancelar
      </button>
      <button class="btn text-white bg-primary-500 border-none hover:bg-primary-600" @click="goToPayment">
        Continuar
      </button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { CheckCircleIcon } from "@heroicons/vue/24/outline";
import type { PropType } from "vue";
import type { Plan } from "@/interfaces/plan";

defineProps({
  plans: {
    type: Array as () => Plan[],
    required: true,
  },
  modelValue: {
    type: String,
    required: true,
  },
  scrollToPlans: {
    type: Function as PropType<(payload: MouseEvent) => void>,
    required: true,
  },
  goToPayment: {
    type: Function as PropType<(payload: MouseEvent) => void>,
    required: true,
  },
});
</script>