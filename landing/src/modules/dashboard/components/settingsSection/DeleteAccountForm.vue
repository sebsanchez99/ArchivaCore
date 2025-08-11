<template>
  <div class="card bg-white shadow rounded border-red-100 flex flex-col p-5">
    <!-- Header -->
    <div class="p-4 bg-red-100">
      <div class="flex items-center gap-3">
        <ExclamationTriangleIcon class="h-6 w-6 text-red-500" />
        <h2 class="text-xl font-semibold text-red-500">Eliminar cuenta</h2>
      </div>
      <p class="text-sm text-red-400">Elimine permanentemente su cuenta y todos sus datos. Esta acción no se puede deshacer.</p>
    </div>

    <!-- Contenido -->
    <div class="pt-4">
      <button v-if="!confirming" class="btn btn-block bg-red-500 hover:bg-red-600 text-white border-none"
        @click="confirming = true">
        Solicitar eliminación de cuenta
      </button>

      <template v-else>
        <p class="text-sm text-red-500 mb-2">
          Para confirmar, escriba <span class="font-bold">ELIMINAR</span>:
        </p>
        <input type="text" class="input bg-white w-full border border-red-500 mb-4"
          placeholder="Escriba ELIMINAR para continuar" v-model="confirmationInput" />
        <div class="flex gap-2">
          <button class="btn btn-ghost hover:bg-primary-500 hover:border-none" @click="cancell"
            :disabled="settingsStore.loading">
            Cancelar
          </button>

          <button v-if="!settingsStore.loading" class="btn bg-red-500 hover:bg-red-600 text-white border-none"
            @click="deleteAccount">
            Confirmar eliminación
          </button>

          <span v-else class="loading loading-spinner text-primary-500"></span>
        </div>
      </template>
    </div>
  </div>

  <SuccessModal ref="successModal" @close="resetMessages" />

  <ErrorModal ref="errorModal" @close="resetMessages" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/authStore"
import { useSettingsStore } from "@/stores/settingsStore"
import SuccessModal from "@/components/modals/SuccessModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"
import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline'

const router = useRouter()
const authStore = useAuthStore()
const settingsStore = useSettingsStore()

const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)
const confirming = ref(false)
const confirmationInput = ref('')

const cancell = () => {
  confirming.value = false
  confirmationInput.value = ''
}

async function deleteAccount() {
  settingsStore.loading = true
  if (confirmationInput.value !== 'ELIMINAR') {
    errorModal.value?.show('La confirmación de eliminación es incorrecta.')
    settingsStore.loading = false
    return
  }
  await settingsStore.deleteCompany()
  const result = settingsStore.response?.result
  if (result) {
    successModal.value?.show(getMessage('Cuenta eliminada con éxito.'))
    authStore.logout()
    setTimeout(() => { router.push('/login') }, 2000)
  } else {
    errorModal.value?.show(getMessage('No se pudo eliminar la cuenta. Intente más tarde.'))
  }
  settingsStore.loading = false
}

function getMessage(defaultMsg: string) {
  return settingsStore.response?.message || defaultMsg
}

function resetMessages() {
  settingsStore.resetMessages()
}
</script>