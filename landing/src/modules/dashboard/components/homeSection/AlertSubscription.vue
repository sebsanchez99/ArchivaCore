<template>
  <div v-if="showAlert" class="alert bg-secondary-100 border-none shadow text-text-500">
    <InformationCircleIcon class="w-6 text-primary-500" />
    <span>
      <template v-if="daysLeft !== null && daysLeft > 0">
        <p class="font-semibold">
          Su cuenta {{ planName || 'DEMO' }} expirará en {{ daysLeft }} día{{ daysLeft === 1 ? '' : 's' }}
        </p>
        <p class="text-text-400">
          Actualice a la versión PRO para disfrutar de todas las funcionalidades de la plataforma.
        </p>
      </template>
      <template v-else>
        <p class="font-semibold text-red-600">
          Su cuenta ha expirado
        </p>
        <p class="text-text-400">
          Por favor, actualice su suscripción para continuar usando la plataforma.
        </p>
      </template>
    </span>
    <RouterLink class="ml-auto" to="/dashboard/plans">
      <button class="btn bg-primary-500 border-none hover:bg-primary-600 text-white">Actualizar ahora</button>
    </RouterLink>
  </div>
</template>

<script setup lang="ts">
import { InformationCircleIcon } from "@heroicons/vue/24/outline";
import { computed } from "vue";
import { useAuthStore } from "@/stores/authStore";

const authStore = useAuthStore();

const planName = computed(() => authStore.getPlanName);
const planDuration = computed(() => authStore.getPlanDuration);
const planStartDate = computed(() => authStore.getPlanStartDate);

// Función para sumar días a una fecha
function addDays(date: Date, days: number): Date {
  const d = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  d.setDate(d.getDate() + days);
  d.setHours(0, 0, 0, 0);
  return d;
}

// --- Cálculo de expiración y días restantes usando addDays ---
const planExpiration = computed(() => {
  if (!planStartDate.value || !planDuration.value) return null;
  const start = new Date(planStartDate.value);
  return addDays(start, Number(planDuration.value));
});

const daysLeft = computed(() => {
  if (!planExpiration.value) return null;
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const expiration = new Date(planExpiration.value);
  expiration.setHours(0, 0, 0, 0);
  const diff = Math.ceil((expiration.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
  return diff;
});

const showAlert = computed(() => {
  if (daysLeft.value === null) return false;
  return daysLeft.value <= 7;
});
</script>