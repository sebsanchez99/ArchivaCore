<template>
  <div class="max-w-6xl mx-auto">
    <div class="mb-8" ref="plansSection">
      <h2 class="text-2xl font-bold text-primary-800 mb-1">Planes y Facturación</h2>
      <p class="text-sm text-primary-600 mb-6">Administra tu suscripción y actualiza tu plan</p>
      <CurrentPlan :currentPlan="currentPlan" :scrollToPayment="scrollToPayment" />
    </div>
    <div v-if="isEditingPlan" ref="tabsSection" class="mt-8 px-4">
      <div class="tabs tabs-border" role="tablist">
        <a role="tab"
          :class="['tab', activeTab === 'plans' ? 'tab-active text-primary-700 font-bold bg-primary-100 hover:text-primary-400' : '']"
          @click="activeTab = 'plans'">
          Planes disponibles
        </a>
        <a role="tab"
          :class="['tab', activeTab === 'payment' ? 'tab-active text-primary-700 font-bold bg-primary-100 hover:text-primary-400' : '']"
          @click="activeTab = 'payment'">
          Método de pago
        </a>
      </div>
      <PlanSelection v-if="activeTab === 'plans'" :plans="plans" v-model="selectedPlan" :scrollToPlans="scrollToPlans"
        :goToPayment="goToPayment" />
        <PaymentMethod
  v-if="activeTab === 'payment'"
  v-model="paymentMethod"
  :selectedPlan="selectedPlan"
  @cancel="scrollToPlans"
/>
    </div>
  </div>
</template>

<script lang="ts" setup>
import CurrentPlan from "../components/plansSection/CurrentPlan.vue";
import PlanSelection from "../components/plansSection/PlanSelection.vue";
import PaymentMethod from "../components/plansSection/PaymentMethod.vue";

import { nextTick, ref } from "vue";
import type { Plan } from "@/interfaces/plan";

const tabsSection = ref<HTMLElement | null>(null);
const plansSection = ref<HTMLElement | null>(null);
const isEditingPlan = ref(false);
const activeTab = ref<"plans" | "payment">("plans");

const demoPlan: Plan = {
  name: "Plan DEMO",
  shortName: "DEMO",
  description: "Estás usando la versión gratuita de ArchivaCore con funciones limitadas.",
  features: ["2 GB de almacenamiento", "Hasta 3 usuarios", "Soporte por correo electrónico"],
  price: "Gratis",
};
const currentPlan = ref<Plan>(demoPlan);

const selectedPlan = ref("Plan DEMO");
const plans: Plan[] = [
  {
    name: "Plan PRO",
    shortName: "PRO",
    description: "Acceso ilimitado a todas las funciones.",
    features: ["Almacenamiento ilimitado", "Usuarios ilimitados", "Soporte prioritario 24/7"],
    price: "$1'000.000",
  },
];

const paymentMethod = ref<"card" | "paypal" | "transfer">("card");

const scrollToPlans = () => {
  isEditingPlan.value = false;
  nextTick(() => {
    plansSection.value?.scrollIntoView({ behavior: "smooth" });
  });
};
const scrollToPayment = () => {
  isEditingPlan.value = true;
  nextTick(() => {
    tabsSection.value?.scrollIntoView({ behavior: "smooth" });
  });
};

const goToPayment = () => {
  activeTab.value = "payment";
};
</script>