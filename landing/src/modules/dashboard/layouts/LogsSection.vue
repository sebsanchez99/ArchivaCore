<template>
    <div class="max-w-8xl mx-auto">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 gap-2">
            <h2 class="text-2xl font-semibold text-text-500">Auditoría de Logs</h2>
            <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                <span class="text-sm text-text-300">
                    Total: {{ filteredLogs.length }} log{{ filteredLogs.length === 1 ? '' : 's' }}
                </span>
                <div class="input bg-white border-primary-500 w-full sm:w-auto">
                    <input v-model="search" type="text" placeholder="Buscar por tabla, tipo o usuario..."
                    class="w-full sm:w-72" />
                </div>
            </div>
            <button class="btn btn-sm bg-error text-white font-semibold" @click="openDeleteLogsModal">
                Eliminar logs por fecha
            </button>
        </div>

        <div class="overflow-x-auto bg-primary-100 rounded-lg shadow border border-base-content/5">
            <table class="table w-full">
                <thead>
                    <tr class="text-left text-sm text-text-400 bg-primary-300">
                        <th>Tabla</th>
                        <th>Tipo</th>
                        <th>Descripción</th>
                        <th>Fecha</th>
                        <th>Usuario</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <LogRow v-for="log in paginatedLogs" :key="log.id" :log="log" @viewDetail="openLogDetailModal" />
                    <tr v-if="filteredLogs.length === 0">
                        <td colspan="6" class="text-center py-4 text-gray-400">No se encontraron logs</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="flex flex-col sm:flex-row justify-between items-center mt-4 gap-3">
            <span class="text-sm text-gray-500">
                Mostrando {{ startItem + 1 }}–{{ endItem }} de {{ filteredLogs.length }} log{{ filteredLogs.length === 1
                ? '' : 's' }}
            </span>
            <div class="flex justify-between gap-3">
                <button class="join-item btn btn-sm bg-primary-500 text-white border-none disabled:opacity-50"
                    :disabled="currentPage === 1" @click="currentPage--">
                    Anterior
                </button>
                <button class="join-item btn btn-sm bg-primary-500 text-white border-none disabled:opacity-50"
                    :disabled="currentPage === totalPages" @click="currentPage++">
                    Siguiente
                </button>
            </div>
        </div>
    </div>
    <DeleteLogsModal
      ref="deleteLogsModal"
      @confirm="handleDeleteLogs"
      @cancel="handleCancelDelete"
    />
    <LogDetailModal ref="logDetailModal" :log="selectedLog" />
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useClientsStore } from '@/stores/clientsStore'
import LogRow from '@/modules/dashboard/components/LogSection/LogRow.vue'
import LogDetailModal from '@/modules/dashboard/components/LogSection/LogDetailModal.vue'
import DeleteLogsModal from '@/modules/dashboard/components/LogSection/DeleteLogsModal.vue'

const clientsStore = useClientsStore()
const { logs } = storeToRefs(clientsStore)

const logDetailModal = ref<InstanceType<typeof LogDetailModal> | null>(null)
const deleteLogsModal = ref<InstanceType<typeof DeleteLogsModal> | null>(null)
const selectedLog = ref(null)
const search = ref('')
const currentPage = ref(1)
const perPage = 10

onMounted(() => {
    clientsStore.fecthLogs()
})

const filteredLogs = computed(() =>
    logs.value.filter(l =>
        (l.table ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
        (l.type ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
        (l.username ?? '').toLowerCase().includes(search.value.toLowerCase())
    )
)

const totalPages = computed(() => Math.ceil(filteredLogs.value.length / perPage))
const paginatedLogs = computed(() => {
    const start = (currentPage.value - 1) * perPage
    return filteredLogs.value.slice(start, start + perPage)
})

const startItem = computed(() => (currentPage.value - 1) * perPage)
const endItem = computed(() => startItem.value + paginatedLogs.value.length)

function openLogDetailModal(log: any) {
    selectedLog.value = log
}

function openDeleteLogsModal() {
  deleteLogsModal.value?.open()
}

async function handleDeleteLogs(date: string) {
  // await clientsStore.deleteLogsFromDate(date)
  await clientsStore.fecthLogs()
}

function handleCancelDelete() {
  // Solo cierra el modal, no hace nada
}
</script>