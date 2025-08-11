<template>
  <div class="card shadow-sm border border-gray-200 mb-6 bg-gradient-to-r from-secondary-50 to-white">
    <div class="card-body p-6">
      <div class="flex items-center gap-4">
        <div class="flex-shrink-0 bg-primary-100 p-3 rounded-full">
          <span class="text-primary-600 text-2xl">👋</span>
        </div>
        <div>
          <h2 class="text-2xl font-bold text-primary-700">
            Bienvenido, <span class="text-primary-500">{{ authStore.getFullname }}</span>
          </h2>
          <p class="text-sm text-gray-600">
            Rol: <span class="font-medium text-primary-500">{{ authStore.getRol }}</span>
          </p>
        </div>
      </div>
      <p class="mt-4 text-gray-700 leading-relaxed">
        Esta es tu vista de inicio como superusuario. Desde aquí puedes supervisar empresas,
        gestionar usuarios, planes y revisar la actividad general del sistema.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from "@/stores/authStore"

const authStore = useAuthStore()
</script>
