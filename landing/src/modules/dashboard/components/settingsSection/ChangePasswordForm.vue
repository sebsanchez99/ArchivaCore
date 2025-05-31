<template>
    <div class="card bg-white shadow rounded border-primary-100 flex flex-col">
      <!-- Header -->
      <div class="p-4 bg-primary-100">
        <h2 class="text-xl font-semibold text-text-400">Cambiar contraseña</h2>
        <p class="text-sm text-text-300">Actualice su contraseña para mantener la seguridad de su cuenta</p>
      </div>
  
      <!-- Formulario -->
      <div class="p-6 space-y-4">
        <!-- Contraseña actual -->
        <div>
          <label class="label text-sm">Contraseña actual</label>
          <div class="relative">
            <input
              :type="showCurrent ? 'text' : 'password'"
              class="input w-full bg-white border border-primary-500 pr-10"
              v-model="currentPassword"
            />
            <button type="button" class="absolute right-2 top-2.5 text-primary-500 cursor-pointer" @click="showCurrent = !showCurrent">
              <component :is="showCurrent ? EyeSlashIcon : EyeIcon" class="h-5 w-5 text-accent-500" />
            </button>
          </div>
        </div>
  
        <!-- Nueva contraseña -->
        <div>
          <label class="label text-sm">Nueva contraseña</label>
          <div class="relative">
            <input
              :type="showNew ? 'text' : 'password'"
              class="input w-full bg-white border border-primary-500 pr-10"
              v-model="newPassword"
            />
            <button type="button" class="absolute right-2 top-2.5 text-primary-500 cursor-pointer" @click="showNew = !showNew">
              <component :is="showNew ? EyeSlashIcon : EyeIcon" class="h-5 w-5 text-accent-500" />
            </button>
          </div>
        </div>
  
        <!-- Confirmar contraseña -->
        <div>
          <label class="label text-sm">Confirmar nueva contraseña</label>
          <div class="relative">
            <input
              :type="showConfirm ? 'text' : 'password'"
              class="input w-full bg-white border border-primary-500 pr-10"
              v-model="confirmPassword"
            />
            <button type="button" class="absolute right-2 top-2.5 text-primary-500 cursor-pointer" @click="showConfirm = !showConfirm">
              <component :is="showConfirm ? EyeSlashIcon : EyeIcon" class="h-5 w-5 text-accent-500" />
            </button>
          </div>
        </div>
      </div>
  
      <!-- Botón -->
      <div class="px-4 pb-4 flex justify-end">
        <button class="btn btn-block bg-primary-500 border-none hover:bg-primary-600 text-white">
          <LockClosedIcon class="w-5 mr-2" />
          Actualizar contraseña
        </button>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue'
  import { EyeIcon, EyeSlashIcon, LockClosedIcon } from '@heroicons/vue/24/outline'
  
  const currentPassword = ref('')
  const newPassword = ref('')
  const confirmPassword = ref('')
  
  const showCurrent = ref(false)
  const showNew = ref(false)
  const showConfirm = ref(false)
  </script>
  