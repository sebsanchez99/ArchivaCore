<template>
  <div class="bg-accent-100 rounded-lg shadow-sm p-5">
    <h2 class="font-semibold text-lg text-text-500">Estado de la cuenta</h2>
    <p class="text-sm text-text-500">Información de la suscripción</p>
    <div class="mt-4 space-y-2 text-sm text-text-400">
      <div class="flex justify-between">
        <span>Plan actual:</span>
        <span class="badge badge-outline font-semibold border border-secondary-500 text-secondary-500">
          {{ plan || "Sin plan" }}
        </span>
      </div>
      <div class="flex justify-between">
        <span>Duración del plan:</span>
        <span class="font-semibold text-secondary-500">
          <template v-if="planDuration">
            {{ planDuration > 31 
              ? (Math.round((planDuration / 30) * 10) / 10) + ' meses' 
              : planDuration + ' días' 
            }}
          </template>
          <template v-else>
            No disponible
          </template>
        </span>
      </div>
      <div class="flex justify-between">
        <span>Estado:</span>
        <span class="font-semibold" :class="active ? 'text-green-600' : 'text-red-600'">
          {{ active ? 'Activa' : 'Inactiva' }}
        </span>
      </div>
      <div class="flex justify-between" v-if="companyName">
        <span>Empresa:</span>
        <span class="font-semibold text-secondary-500">{{ companyName }}</span>
      </div>
    </div>
    <RouterLink
      v-if="plan === 'DEMO'"
      to="/dashboard/plans"
      class="btn bg-primary-500 border-none btn-block mt-4 hover:bg-primary-600 text-white"
    >
      Actualizar a plan completo
    </RouterLink>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  plan?: string | null;
  planDuration?: number | null;
  active?: boolean | null;
  companyName?: string | null;
}>();
</script>