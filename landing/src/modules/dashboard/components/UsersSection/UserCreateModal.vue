<template>
  <dialog ref="dialog" class="modal">
    <div class="modal-box bg-white max-w-md">
      <form @submit.prevent="submit">
        <h3 class="font-bold text-lg mb-4">Crear {{ roleLabel }}</h3>
        <FormField id="name" label="Nombre de usuario" v-model="fields.name" :error="errors.name"
          placeholder="Usuario" />
        <FormField id="fullname" label="Nombre completo" v-model="fields.fullname" :error="errors.fullname"
          placeholder="Nombre completo" />
        <PasswordField id="password" label="Contraseña" v-model="fields.password" :error="errors.password"
          placeholder="Contraseña" :showPassword="showPassword" @toggle-password="togglePassword" />
        <PasswordField id="confirmPassword" label="Confirmar contraseña" v-model="fields.confirmPassword"
          :error="errors.confirmPassword" placeholder="Confirmar contraseña" :showPassword="showPassword"
          @toggle-password="togglePassword" />
        <div class="modal-action flex justify-end gap-2">
          <button type="button" class="btn btn-error text-white" @click="close">Cancelar</button>
          <button type="submit" class="btn bg-primary-500 text-white border-none hover:bg-primary-600">Crear</button>
        </div>
      </form>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import FormField from '@/components/inputs/FormField.vue'
import PasswordField from '@/components/inputs/PasswordField.vue'
import { useFormValidation } from '@/composables/useFormValidation'
import { useTogglePassword } from '@/composables/useTogglePassword'
import { required, onlyLettersAndSpaces, strongPassword } from '@/utils/validators'
import { useClientsStore } from '@/stores/clientsStore'

const props = defineProps<{ role: 'Superusuario' | 'Asesor' }>()
const emit = defineEmits(['created'])

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
  password: [required, strongPassword],
  confirmPassword: [
    required,
    (value: string, fields: any) => value === fields.password ? '' : 'Las contraseñas no coinciden',
  ],
}

const { fields, errors, validateAll, resetFields } = useFormValidation(initialFields, validators)

function open() {
  resetFields()
  if (dialog.value && !dialog.value.open) dialog.value.showModal()
}

function close() {
  dialog.value?.close()
}

async function submit() {
  validateAll()
  if (props.role === 'Superusuario') {
    await clientsStore.createSuperuser(fields.name, fields.fullname, fields.password)
  } else {
    await clientsStore.createSupportUser(fields.name, fields.fullname, fields.password)
  }
  resetFields()
  if(clientsStore.response?.result) close()
  emit('created')
}

const roleLabel = computed(() => props.role === 'Superusuario' ? 'superusuario' : 'usuario soporte')

const dialog = ref<HTMLDialogElement | null>(null)
defineExpose({ open })
</script>