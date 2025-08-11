<template>
  <form class="card bg-white shadow rounded border-primary-100 flex flex-col" @submit.prevent="openChangePassword">
    <!-- Header -->
    <div class="p-4 bg-primary-100">
      <h2 class="text-xl font-semibold text-text-400">Cambiar contraseña</h2>
      <p class="text-sm text-text-300">Actualice su contraseña para mantener la seguridad de su cuenta</p>
    </div>

    <!-- Formulario -->
    <div class="p-6">
      <!-- Nueva contraseña -->
      <PasswordField id="password" label="Nueva contraseña" v-model="fields.password" :error="errors.password"
        placeholder="Nueva contraseña" :showPassword="showPassword" @togglePassword="togglePassword" />

      <PasswordField id="confirmPassword" label="Confirmar contraseña" v-model="fields.confirmPassword"
        :error="errors.confirmPassword" placeholder="Confirmar nueva contraseña" :showPassword="showPassword"
        @togglePassword="togglePassword" />
    </div>

    <!-- Botón -->
    <div class="px-5 pb-5">
      <button
        class="btn btn-block bg-primary-500 border-none hover:bg-primary-600 text-white flex items-center justify-center gap-2"
        :disabled="settingsStore.loading">
        <span v-if="settingsStore.loading" class="loading loading-spinner loading-sm"></span>
        <span v-else>Actualizar contraseña</span>
      </button>
    </div>
  </form>

  <InfoModal ref="changePasswordModal" :title="'Actualizar contraseña'"
    :message="`¿Está seguro de que desea actualizar la contraseña?`" :onConfirmAction="changePassword"
    :onCancelAction="handleCancel" alert-message="Se cerrará la sesión una vez que se actualice la contraseña." />

  <SuccessModal ref="successModal" @close="resetMessages" />

  <ErrorModal ref="errorModal" @close="resetMessages" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/authStore"
import { useSettingsStore } from "@/stores/settingsStore"
import { useFormValidation } from "@/composables/useFormValidation";
import { required, strongPassword } from "@/utils/validators";
import { useTogglePassword } from '@/composables/useTogglePassword'
import PasswordField from '@/components/inputs/PasswordField.vue'
import InfoModal from "@/components/modals/InfoModal.vue"
import SuccessModal from "@/components/modals/SuccessModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"

const router = useRouter()
const authStore = useAuthStore()
const settingsStore = useSettingsStore()

const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)
const changePasswordModal = ref<InstanceType<typeof InfoModal> | null>(null)

const initialFields = {
  password: '',
  confirmPassword: ''
}

const validators = {
  password: [
    required,
    (value: string) => {
      if (!value) return ''
      return strongPassword(value)
    }
  ],
  confirmPassword: [
    required,
    (value: string, fields: any) => {
      if (!fields.password) return ''
      return value === fields.password ? '' : 'Las contraseñas no coinciden'
    },
  ],
}

const { fields, errors, validateAll } = useFormValidation(initialFields, validators)
const { showPassword, togglePassword } = useTogglePassword()

function openChangePassword() {
  const isValid = validateAll()
  if (!isValid) return
  changePasswordModal.value?.open()
}

async function changePassword() {
  settingsStore.loading = true
  await settingsStore.changeCompanyPassword(fields.password)
  const result = settingsStore.response?.result
  if (result) {
    successModal.value?.show(getMessage('Contraseña actualizada con éxito.'))
    authStore.logout()
    setTimeout(() => { router.push('/login') }, 2000)
  } else {
    errorModal.value?.show(getMessage('No se pudo actualizar la contraseña. Intente más tarde.'))
  }
  settingsStore.loading = false
}

function handleCancel() {
  changePasswordModal.value?.close()
}

function getMessage(defaultMsg: string) {
  return settingsStore.response?.message || defaultMsg
}

function resetMessages() {
  settingsStore.resetMessages()
}
</script>