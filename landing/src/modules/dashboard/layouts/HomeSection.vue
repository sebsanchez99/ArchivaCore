<template>
  <div class="space-y-6">
    <AlertSubscription />

    <div class="my-6">
      <h1 class="text-xl font-semibold text-text-500">Bienvenido, {{authStore.getCompanyName}}</h1>
      <p class="text-sm text-text-400">Panel de Administración de su cuenta ArchivaCore</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <StorageCard :storage="homeStore.storage || null" />
      <AccountStatusCard
        :plan="authStore.getPlanName"
        :plan-duration="authStore.getPlanDuration"
        :active="authStore.getActive"
        :company-name="authStore.getCompanyName"
      />
      <QuickAccessCard />
    </div>
  </div>
</template>

<script setup lang="ts">
import { useHomeStore } from "@/stores/homeStore";
import { useAuthStore } from "@/stores/authStore";
import AlertSubscription from "@/modules/dashboard/components/homeSection/AlertSubscription.vue";
import StorageCard from "@/modules/dashboard/components/homeSection/StorageCard.vue";
import AccountStatusCard from "@/modules/dashboard/components/homeSection/AccountStatusCard.vue";
import QuickAccessCard from "@/modules/dashboard/components/homeSection/QuickAccessCard.vue";
import { onMounted } from "vue";

const homeStore = useHomeStore();
const authStore = useAuthStore();

onMounted(() => {
  homeStore.loading = true;
  homeStore.fetchStorage();
  homeStore.loading = false;
});
</script>