<template>
    <div class="card bg-white shadow rounded border-primary-100 flex flex-col">
      <!-- Header -->
      <div class="p-4 bg-primary-100">
        <h2 class="text-xl font-semibold text-red-500">Eliminar cuenta</h2>
        <p class="text-sm text-red-400">Elimine permanentemente su cuenta y todos sus datos</p>
      </div>
  
      <!-- Contenido -->
      <div class="p-6">
        <div v-if="!confirming">
          <div class="alert bg-white text-red-500 text-sm mb-4 border-red-500">
            <ExclamationTriangleIcon class="w-5 h-5 mr-2" />
            <div>
                <h3 class="font-bold">Advertencia: Esta acción es irreversible</h3>
                <p>Al eliminar su cuenta, todos sus datos, archivos y configuraciones serán eliminados permanentemente. Esta acción no se puede deshacer</p>
            </div>
          </div>
          <button
            class="btn btn-block bg-red-500 hover:bg-red-600 text-white border-none"
            @click="confirming = true"
          >
            Solicitar eliminación de cuenta
          </button>
        </div>
  
        <div v-else>
          <p class="text-sm text-red-500 mb-2">
            Para confirmar, escriba <span class="font-bold">ELIMINAR</span> en el siguiente campo:
          </p>
          <input
            type="text"
            class="input bg-white w-full border border-red-500 mb-4"
            placeholder="Escriba ELIMINAR para continuar"
            v-model="confirmationInput"
          />
          <div class="flex  gap-2">
            <button
              class="btn btn-ghost hover:bg-primary-500 hover:border-none"
              @click="cancelarProceso"
            >
              Cancelar
            </button>
            <button
              class="btn bg-red-500 hover:bg-red-600 text-white border-none"
              @click=""
            >
              Confirmar eliminación
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue'
  import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline'
  
  const confirming = ref(false)
  const confirmationInput = ref('')
  
  const cancelarProceso = () => {
    confirming.value = false
    confirmationInput.value = ''
  }
  
  </script>
  