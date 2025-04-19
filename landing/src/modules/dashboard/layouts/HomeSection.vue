<template>
    <div class="space-y-6">
      <AlertSubscription />
  
      <div class="my-6">
        <h1 class="text-xl font-bold text-text-500">Bienvenido, nombreEmpresa</h1>
        <p class="text-sm text-text-400">Panel de Administración de su cuenta ArchivaCore</p>
      </div>
  
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StorageCard />
        <AccountStatusCard />
        <QuickAccessCard />
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import AlertSubscription from "@/modules/dashboard/components/homeSection/AlertSubscription.vue";
  import StorageCard from "@/modules/dashboard/components/homeSection/StorageCard.vue";
  import AccountStatusCard from "@/modules/dashboard/components/homeSection/AccountStatusCard.vue";
  import QuickAccessCard from "@/modules/dashboard/components/homeSection/QuickAccessCard.vue";
  </script>
  