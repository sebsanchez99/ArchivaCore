<template>
  <dialog ref="dialog" class="modal z-50">
    <div class="modal-box bg-white max-w-md">
      <form @submit.prevent="submit">
        <h3 class="font-bold text-lg mb-4">Editar usuario</h3>
        <FormField id="name" label="Nombre de usuario" v-model="fields.name" :error="errors.name"
          placeholder="Usuario" />
        <FormField id="fullname" label="Nombre completo" v-model="fields.fullname" :error="errors.fullname"
          placeholder="Nombre completo" />
        <PasswordField id="password" label="Nueva contraseña (opcional)" v-model="fields.password"
          :error="errors.password" placeholder="Nueva contraseña" :showPassword="showPassword"
          @toggle-password="togglePassword" />
        <PasswordField id="confirmPassword" label="Confirmar nueva contraseña" v-model="fields.confirmPassword"
          :error="errors.confirmPassword" placeholder="Confirmar nueva contraseña" :showPassword="showPassword"
          @toggle-password="togglePassword" />
        <div class="modal-action flex justify-end gap-2">
          <button type="button" class="btn" @click="close">Cancelar</button>
          <button type="submit" class="btn bg-primary-500 text-white">Guardar</button>
        </div>
      </form>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import FormField from '@/components/inputs/FormField.vue'
import PasswordField from '@/components/inputs/PasswordField.vue'
import { useFormValidation } from '@/composables/useFormValidation'
import { strongPassword, passwordsMatch } from '@/utils/validators'
import { useTogglePassword } from '@/composables/useTogglePassword'
import type { AdminUser } from '@/interfaces/adminUser'

const props = defineProps<{ user: AdminUser | null }>()
const emit = defineEmits(['saved'])

const initialFields = {
  name: '',
  fullname: '',
  password: '',
  confirmPassword: '',
}

const validators = {
  // Solo valida si el campo tiene valor
  password: [
    (value: string) => !value || strongPassword(value) || 'Contraseña débil',
  ],
  confirmPassword: [
    (value: string, fields: any) =>
      !fields.password || value === fields.password || 'Las contraseñas no coinciden',
  ],
}

const { fields, errors, validateAll, resetFields } = useFormValidation(initialFields, validators)
const { showPassword, togglePassword } = useTogglePassword()
const dialog = ref<HTMLDialogElement | null>(null)

function open(user: AdminUser) {
  if (dialog.value && !dialog.value.open) {

    fields.name = props.user!.name
    fields.fullname = props.user!.fullname
    fields.password = ''
    fields.confirmPassword = ''
    errors.name = ''
    errors.fullname = ''
    errors.password = ''
    errors.confirmPassword = ''
    dialog.value?.showModal()
  }
}


function close() {
  dialog.value?.close()
}

function submit() {
  if (!validateAll()) return
  // Solo envía los campos que el usuario editó
  const payload: any = {}
  if (fields.name && fields.name !== props.user?.name) payload.name = fields.name
  if (fields.fullname && fields.fullname !== props.user?.fullname) payload.fullname = fields.fullname
  if (fields.password) payload.password = fields.password
  emit('saved', payload)
  close()
}

defineExpose({ open, close })
</script>