<template>
  <dialog ref="dialog" class="modal z-50">
    <div class="modal-box bg-white">
      <form method="dialog">
        <button class="btn btn-xs btn-circle absolute right-2 top-2 text-white bg-red-400 border-none">✕</button>
      </form>

      <div class="flex items-center gap-2">
        <XCircleIcon class="w-6 h-6 text-red-500" />
        <h3 class="font-bold text-lg text-red-500">¡Error!</h3>
      </div>

      <p class="mt-2 text-gray-600">{{ message }}</p>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { XCircleIcon } from '@heroicons/vue/24/solid'

const dialog = ref<HTMLDialogElement | null>(null)
const message = ref('')

function show(msg: string, duration = 3000) {
  message.value = msg

  if (dialog.value && !dialog.value.open) {
    dialog.value.showModal()

    setTimeout(() => {
      dialog.value?.close()
    }, duration)
  }
}

defineExpose({ show })
</script>
