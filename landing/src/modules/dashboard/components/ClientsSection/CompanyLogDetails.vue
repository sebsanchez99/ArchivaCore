<template>
  <dialog ref="dialog" class="modal z-50">
    <div class="modal-box bg-white max-w-5xl max-h-[90vh] overflow-y-auto shadow-xl border border-gray-300 rounded-xl">
      <form method="dialog">
        <button
          class="btn btn-xs btn-circle absolute right-2 top-2 text-white bg-red-500 hover:bg-red-600 border-none transition"
          @click="close"
        >
          ✕
        </button>
      </form>

      <!-- Encabezado -->
      <div class="flex items-center gap-3 mb-6 border-b pb-3">
        <svg class="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M12 20a8 8 0 100-16 8 8 0 000 16z" />
        </svg>
        <div>
          <h3 class="text-xl font-bold text-primary-700 leading-tight">Historial de cambios</h3>
          <p class="text-sm text-gray-500">Cliente: {{ client?.name }}</p>
        </div>
      </div>

      <!-- Datos del cliente -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-3 mb-6 text-sm">
        <div><span class="font-medium text-gray-600">Nombre:</span> <span class="text-gray-800">{{ client?.name }}</span></div>
        <div><span class="font-medium text-gray-600">Nombre completo:</span> <span class="text-gray-800">{{ client?.fullname }}</span></div>
        <div><span class="font-medium text-gray-600">Correo:</span> <span class="text-gray-800">{{ client?.email }}</span></div>
        <div><span class="font-medium text-gray-600">Plan:</span> <span class="text-gray-800">{{ client?.planName }}</span></div>
        <div><span class="font-medium text-gray-600">Fecha de registro:</span> <span class="text-gray-800">{{ formatDate(client?.registerDate) }}</span></div>
        <div><span class="font-medium text-gray-600">Fecha inicial:</span> <span class="text-gray-800">{{ formatDate(client?.initialDate) }}</span></div>
        <div><span class="font-medium text-gray-600">Activo:</span> <span :class="client?.active ? 'text-green-600' : 'text-red-600'">{{ client?.active ? 'Sí' : 'No' }}</span></div>
      </div>

      <!-- Filtros -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6 text-sm">
        <div>
          <label class="block mb-1 text-gray-600 font-medium">Tabla</label>
          <select v-model="filters.table" class="w-full border-gray-300 rounded-md text-sm">
            <option value="">Todas</option>
            <option v-for="option in tableOptions" :key="option" :value="option">{{ option }}</option>
          </select>
        </div>
        <div>
          <label class="block mb-1 text-gray-600 font-medium">Tipo</label>
          <select v-model="filters.type" class="w-full border-gray-300 rounded-md text-sm">
            <option value="">Todos</option>
            <option v-for="option in typeOptions" :key="option" :value="option">{{ option }}</option>
          </select>
        </div>
        <div>
          <label class="block mb-1 text-gray-600 font-medium">Desde</label>
          <input type="date" v-model="filters.startDate" class="w-full border-gray-300 rounded-md text-sm" />
        </div>
        <div>
          <label class="block mb-1 text-gray-600 font-medium">Hasta</label>
          <input type="date" v-model="filters.endDate" class="w-full border-gray-300 rounded-md text-sm" />
        </div>
      </div>

      <!-- Lista de logs -->
      <div class="space-y-6">
        <div v-if="loading" class="text-center py-10 text-gray-500">Cargando logs...</div>

        <div v-else-if="paginatedLogs.length > 0">
          <div
            v-for="log in paginatedLogs"
            :key="log.id"
            class="rounded-lg border border-gray-200 shadow-sm p-4 bg-gray-50"
          >
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-2 text-sm mb-3">
              <div><span class="font-medium text-gray-600">ID:</span> <span class="text-gray-800">{{ log.id }}</span></div>
              <div><span class="font-medium text-gray-600">Tabla:</span> <span class="text-gray-800">{{ log.table }}</span></div>
              <div><span class="font-medium text-gray-600">Registro:</span> <span class="text-gray-800">{{ log.register }}</span></div>
              <div><span class="font-medium text-gray-600">Tipo:</span> <span class="text-gray-800">{{ log.type }}</span></div>
              <div class="md:col-span-2"><span class="font-medium text-gray-600">Descripción:</span> <span class="text-gray-800">{{ log.description }}</span></div>
              <div><span class="font-medium text-gray-600">Fecha:</span> <span class="text-gray-800">{{ formatDate(log.date) }}</span></div>
              <div><span class="font-medium text-gray-600">Usuario:</span> <span class="text-gray-800">{{ log.username || 'Desconocido' }}</span></div>
              <div><span class="font-medium text-gray-600">Usuario ID:</span> <span class="text-gray-800">{{ log.user || 'N/A' }}</span></div>
            </div>
          </div>

          <!-- Paginación -->
          <div class="flex justify-between items-center pt-4 text-sm">
            <button class="btn btn-sm" @click="currentPage--" :disabled="currentPage === 1">Anterior</button>
            <span>Página {{ currentPage }} de {{ totalPages }}</span>
            <button class="btn btn-sm" @click="currentPage++" :disabled="currentPage === totalPages">Siguiente</button>
          </div>
        </div>

        <div v-else class="text-center text-sm text-gray-500 italic">No hay logs disponibles para esta empresa.</div>
      </div>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import type { Client } from '@/interfaces/client'
import { useClientsStore } from '@/stores/clientsStore'

const props = defineProps<{ client: Client | null }>()
const dialog = ref<HTMLDialogElement | null>(null)
const clientStore = useClientsStore()
const loading = ref(false)

const filters = ref({
  table: '',
  type: '',
  startDate: '',
  endDate: ''
})

const currentPage = ref(1)
const itemsPerPage = 5

const filteredLogs = computed(() => {
  return clientStore.companyLogs.filter(log => {
    const matchTable = !filters.value.table || log.table === filters.value.table
    const matchType = !filters.value.type || log.type === filters.value.type
    const matchStart = !filters.value.startDate || new Date(log.date) >= new Date(filters.value.startDate)
    const matchEnd = !filters.value.endDate || new Date(log.date) <= new Date(filters.value.endDate)
    return matchTable && matchType && matchStart && matchEnd
  })
})

const paginatedLogs = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  return filteredLogs.value.slice(start, start + itemsPerPage)
})

const totalPages = computed(() => Math.ceil(filteredLogs.value.length / itemsPerPage))

const tableOptions = computed(() => [...new Set(clientStore.companyLogs.map(log => log.table))])
const typeOptions = computed(() => [...new Set(clientStore.companyLogs.map(log => log.type))])

watch(() => props.client, async (client) => {
  if (client && dialog.value && !dialog.value.open) {
    currentPage.value = 1
    filters.value = { table: '', type: '', startDate: '', endDate: '' }
    loading.value = true
    await clientStore.fetchCompanyLogs(client.id)
    loading.value = false
    dialog.value.showModal()
  }
})

function close() {
  dialog.value?.close()
}

function formatDate(date?: Date | string) {
  return date ? new Date(date).toLocaleString('es-ES') : ''
}

function formatObject(obj: Record<string, any> | null | undefined) {
  if (!obj) return 'Sin datos'
  const clone = { ...obj }
  if ('usu_hash' in clone) clone.usu_hash = 'Contraseña cambiada'
  return JSON.stringify(clone, null, 2)
}
</script>
