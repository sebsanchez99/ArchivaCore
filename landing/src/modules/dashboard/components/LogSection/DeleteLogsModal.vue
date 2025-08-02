<template>
  <dialog ref="dialog" class="modal z-50">
    <div class="modal-box bg-white max-w-sm">
      <form method="dialog">
        <button class="btn btn-xs btn-circle absolute right-2 top-2 text-white bg-red-500 border-none">✕</button>
      </form>
      <h3 class="font-bold text-lg mb-2 text-red-500">Eliminar logs por fecha</h3>
      <p class="mb-4 text-gray-500 text-sm">Seleccione la fecha desde la cual desea eliminar los logs. Esta acción no se puede deshacer.</p>
      <input v-model="date" type="date" class="input mb-4 border-primary-500 bg-white" />
      <div class="flex justify-end gap-2">
        <button class="btn btn-sm text-white bg-red-600 border-none hover:bg-red-500" @click.prevent="cancel">Cancelar</button>
        <button class="btn btn-sm text-white bg-primary-600 border-none hover:bg-primary-500" :disabled="!date" @click.prevent="confirm">Eliminar</button>
      </div>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
const date = ref('')
const dialog = ref<HTMLDialogElement | null>(null)

function open() {
  date.value = ''
  dialog.value?.showModal()
}
function close() {
  dialog.value?.close()
}
function confirm() {
  if (date.value) {
    close()
    emit('confirm', date.value)
  }
}
function cancel() {
  close()
  emit('cancel')
}
const emit = defineEmits(['confirm', 'cancel'])
defineExpose({ open })
</script>

<style scoped>
input[type="date"]::-webkit-calendar-picker-indicator {
  filter: invert(0%) sepia(0%) saturate(0%) hue-rotate(0deg) brightness(0%) contrast(100%);
}
</style>