<template>
  <dialog ref="dialog" class="modal z-50">
    <div class="modal-box bg-white max-w-2xl max-h-[90vh] overflow-y-auto shadow-lg border border-gray-200">
      <form method="dialog">
        <button class="btn btn-xs btn-circle absolute right-2 top-2 text-white bg-red-500 border-none hover:bg-red-600 transition">✕</button>
      </form>
      <div class="flex items-center gap-2 mb-4">
        <svg class="w-7 h-7 text-primary-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M12 20a8 8 0 100-16 8 8 0 000 16z" />
        </svg>
        <h3 class="font-bold text-2xl text-primary-600">Detalle de Log</h3>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-2 mb-4">
        <div><span class="font-semibold text-gray-600">ID:</span> <span class="text-gray-800">{{ log?.id }}</span></div>
        <div><span class="font-semibold text-gray-600">Tabla:</span> <span class="text-gray-800">{{ log?.table }}</span></div>
        <div><span class="font-semibold text-gray-600">Registro:</span> <span class="text-gray-800">{{ log?.register }}</span></div>
        <div><span class="font-semibold text-gray-600">Tipo:</span> <span class="text-gray-800">{{ log?.type }}</span></div>
        <div class="md:col-span-2"><span class="font-semibold text-gray-600">Descripción:</span> <span class="text-gray-800">{{ log?.description }}</span></div>
        <div><span class="font-semibold text-gray-600">Fecha:</span> <span class="text-gray-800">{{ formatDate(log?.date) }}</span></div>
        <div><span class="font-semibold text-gray-600">Usuario:</span> <span class="text-gray-800">{{ log?.username || 'Desconocido' }}</span></div>
        <div><span class="font-semibold text-gray-600">Usuario ID:</span> <span class="text-gray-800">{{ log?.user || 'N/A' }}</span></div>
      </div>
      <div class="divider my-2">Datos anteriores</div>
      <pre class="bg-gray-50 border border-gray-200 p-3 rounded text-xs whitespace-pre-wrap break-all max-w-full mb-4 font-mono text-gray-700">{{ formatObject(log?.oldData) }}</pre>
      <div class="divider my-2">Datos nuevos</div>
      <pre class="bg-gray-50 border border-gray-200 p-3 rounded text-xs whitespace-pre-wrap break-all max-w-full font-mono text-gray-700">{{ formatObject(log?.newData) }}</pre>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import type { Log } from '@/interfaces/log'

const props = defineProps<{ log: Log | null }>()
const dialog = ref<HTMLDialogElement | null>(null)

watch(() => props.log, (val) => {
  if (val && dialog.value && !dialog.value.open) {
    dialog.value.showModal()
  }
})

function close() {
  dialog.value?.close()
}

function formatDate(date?: Date) {
  return date ? new Date(date).toLocaleString('es-ES') : ''
}

function formatObject(obj: Record<string, any> | null | undefined) {
  if (!obj) return 'Sin datos'
  const clone = { ...obj }
  if ('usu_hash' in clone) {
    clone.usu_hash = 'Contraseña cambiada'
  }
  return JSON.stringify(clone, null, 2)
}
</script>