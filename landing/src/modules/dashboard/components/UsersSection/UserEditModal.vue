<template>
  <dialog ref="dialog" class="modal">
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
          <button type="button" class="btn btn-error text-white" @click="close">Cancelar</button>
          <button type="submit" class="btn bg-primary-500 text-white border-none hover:bg-primary-600">Guardar</button>
        </div>
      </form>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import FormField from '@/components/inputs/FormField.vue'
import PasswordField from '@/components/inputs/PasswordField.vue'
import { useFormValidation } from '@/composables/useFormValidation'
import { required, onlyLettersAndSpaces, strongPassword } from '@/utils/validators'
import { useTogglePassword } from '@/composables/useTogglePassword'
import type { AdminUser } from '@/interfaces/adminUser'
import { useClientsStore } from '@/stores/clientsStore'

const props = defineProps<{ user: AdminUser | null }>()
const emit = defineEmits(['saved'])
const dialog = ref<HTMLDialogElement | null>(null)

const { showPassword, togglePassword } = useTogglePassword()
const clientsStore = useClientsStore()

const initialFields = {
  name: '',
  fullname: '',
  password: '',
  confirmPassword: '',
}

const validators = {
  name: [required],
  fullname: [required, onlyLettersAndSpaces],
  password: [
    (value: string) => {
      if (!value) return ''  
      return strongPassword(value)
    }
  ],
  confirmPassword: [
    (value: string, fields: any) => {
      if (!fields.password) return ''
      return value === fields.password ? '' : 'Las contraseñas no coinciden'
    },
  ],
}

const { fields, errors, validateAll, resetFields } = useFormValidation(initialFields, validators)

function open(user: AdminUser) {
  resetFields()
  fields.name = user.name
  fields.fullname = user.fullname
  dialog.value?.showModal()
}

function close() {
  dialog.value?.close()
}

async function submit() {
  validateAll()  
  await clientsStore.updateAdminUser(props.user!.id , fields.name, fields.fullname, fields.password)
  resetFields()
  if(clientsStore.response?.result) close()
  emit('saved')
}

defineExpose({ open, close })
</script>