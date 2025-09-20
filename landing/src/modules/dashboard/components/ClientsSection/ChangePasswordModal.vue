<template>
  <dialog ref="modalRef" class="modal">
    <div class="modal-box bg-white">
      <h3 class="font-semibold text-lg text-text-500">Cambiar contraseña</h3>
      <p class="py-2 text-text-300 text-sm">
        Establecer nueva contraseña para la empresa <strong>{{ company?.name }}</strong>.
      </p>

      <form class="space-y-4">
        <div class="form-control">
          <PasswordField
            id="password"
            label="Contraseña"
            v-model="fields.password"
            :error="errors.password"
            :show-password="showPassword"
            @toggle-password="togglePassword"
          />
        </div>
        <div class="form-control">
          <PasswordField
            id="confirmPassword"
            label="Confirmar Contraseña"
            v-model="fields.confirmPassword"
            :error="errors.confirmPassword"
            :show-password="showConfirmPassword"
            @toggle-password="toggleConfirmPassword"
          />
        </div>
      </form>

      <p class="mt-3 text-sm text-text-300">
        La nueva contraseña será enviada al correo electrónico principal de la empresa: {{ company?.email }}
      </p>

      <div class="modal-action">
        <form method="dialog" class="space-x-2">
          <button class="btn text-white bg-red-600 border-none hover:bg-red-500">Cancelar</button>
          <button class="btn text-white bg-primary-600 border-none hover:bg-primary-500" @click.prevent="$emit('passwordChanged')">
            <LockClosedIcon class="w-4 mr-2" /> Cambiar contraseña
          </button>
        </form>
      </div>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Client } from '@/interfaces/client'
import { LockClosedIcon } from '@heroicons/vue/24/outline'
import PasswordField from '@/components/inputs/PasswordField.vue'
import { useFormValidation } from '@/composables/useFormValidation'
import { required, strongPassword, passwordsMatch } from '@/utils/validators'
import { useTogglePassword } from '@/composables/useTogglePassword'
import { useClientsStore } from '@/stores/clientsStore'

const props = defineProps<{ company: Client | null }>()

const modalRef = ref<HTMLDialogElement | null>(null)

const emit = defineEmits<{
  (e: 'passwordChanged'): void
}>()

const clientsStore = useClientsStore()

const { fields, errors, validateAll, resetFields } = useFormValidation(
  {
    password: '',
    confirmPassword: ''
  },
  {
    password: [required, strongPassword],
    confirmPassword: [required, passwordsMatch]
  }
)

const { showPassword, togglePassword } = useTogglePassword()
const { showPassword: showConfirmPassword, togglePassword: toggleConfirmPassword } = useTogglePassword()

function open() {
  fields.password = ''
  fields.confirmPassword = ''
  modalRef.value?.showModal()
}

function close() {
  modalRef.value?.close()
}

async function submit() {
  const isValid = await validateAll()
  if (!isValid) return
  await clientsStore.changePassword(props.company!.id, fields.password)
  const result = clientsStore.response!.result ? true : false
  close()
  await resetFields()
  return result
}

defineExpose({ open, submit })
</script>
