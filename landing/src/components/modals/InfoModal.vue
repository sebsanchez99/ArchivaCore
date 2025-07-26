<template>
  <dialog ref="dialogRef" class="modal" @cancel.prevent>
    <div class="modal-box bg-white">
      <h3 class="font-semibold text-lg text-text-400">{{ title }}</h3>
      <p class="py-2 text-text-300 text-sm" v-if="message">{{ message }}</p>

      <p v-if="alertMessage" class="alert text-sm text-red-500 bg-white border-red-500 shadow-sm">
        <ExclamationCircleIcon class="w-6 inline-block mr-2" />
        {{ alertMessage }}
      </p>

      <div class="modal-action">
        <form method="dialog" class="space-x-2">
          <button type="button"
            class="btn text-white bg-red-600 border-none hover:bg-red-500"
            @click="handleCancel">Cancelar</button>

          <button type="button"
            class="btn text-white bg-primary-600 border-none hover:bg-primary-500"
            @click="handleConfirm">Confirmar</button>
        </form>
      </div>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ExclamationCircleIcon } from '@heroicons/vue/24/solid'

const dialogRef = ref<HTMLDialogElement>()

const {
  title,
  message,
  alertMessage,
  onConfirmAction,
  onCancelAction
} = defineProps<{
  title: string
  message?: string
  alertMessage?: string
  onConfirmAction: () => void
  onCancelAction: () => void
}>()

function open() {
  dialogRef.value?.showModal()
}

function close() {
  dialogRef.value?.close()
}

function handleConfirm() {
  onConfirmAction()
  close()
}

function handleCancel() {
  onCancelAction()
  close()
}

defineExpose({ open, close })

</script>
