<template>
    <div class="max-w-8xl mx-auto">
        <!-- Encabezado -->
        <div v-if="clientsStore.loading" class="flex justify-center items-center h-64">
            <span class="loading loading-spinner loading-lg text-primary-500"></span>
        </div>
        <div v-else>
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
                <button class="btn btn-sm bg-error text-white font-semibold border-none" @click="openDeleteLogsModal">
                    Eliminar logs por fecha
                </button>
            </div>
            <!-- Filtros -->
            <div class="flex flex-wrap gap-4 mb-4">
                <div class="flex flex-col">
                    <label for="start-date" class="text-xs text-gray-600 mb-1">Desde</label>
                    <input id="start-date" v-model="startDate" type="date"
                        class="input bg-white border-primary-500 w-full sm:w-auto" />
                </div>
                <div class="flex flex-col">
                    <label for="end-date" class="text-xs text-gray-600 mb-1">Hasta</label>
                    <input id="end-date" v-model="endDate" type="date"
                        class="input bg-white border-primary-500 w-full sm:w-auto" />
                </div>
                <div class="input bg-white border w-full sm:w-48">
                    <select v-model="selectedTable" class="w-full">
                        <option value="">Todas las tablas</option>
                        <option v-for="table in uniqueTables" :key="table" :value="table">{{ table }}</option>
                    </select>
                </div>
                <div class="input bg-white border w-full sm:w-48">
                    <select v-model="selectedType" class="w-full">
                        <option value="">Todos los tipos</option>
                        <option v-for="type in uniqueTypes" :key="type" :value="type">{{ type }}</option>
                    </select>
                </div>
                <div class="input bg-white border w-full sm:w-48">
                    <select v-model="selectedUser" class="w-full">
                        <option value="">Todos los usuarios</option>
                        <option v-for="user in uniqueUsers" :key="user!" :value="user">{{ user }}</option>
                    </select>
                </div>
            </div>
            <!-- Tabla -->
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
                        <LogRow v-for="log in paginatedLogs" :key="log.id" :log="log"
                            @viewDetail="openLogDetailModal" />
                        <tr v-if="filteredLogs.length === 0">
                            <td colspan="6" class="text-center py-4 text-gray-400">No se encontraron logs</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- Paginación -->
            <div class="flex flex-col sm:flex-row justify-between items-center mt-4 gap-3">
                <span class="text-sm text-gray-500">
                    Mostrando {{ startItem + 1 }}–{{ endItem }} de {{ filteredLogs.length }} log{{ filteredLogs.length
                        === 1
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
    </div>

    <DeleteLogsModal ref="deleteLogsModal" @confirm="handleDeleteLogs" />
    <LogDetailModal ref="logDetailModal" :log="selectedLog" />

    <SuccessModal ref="successModal" @close="resetMessages" />
    <ErrorModal ref="errorModal" @close="resetMessages" />
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useClientsStore } from '@/stores/clientsStore'
import LogRow from '@/modules/dashboard/components/LogSection/LogRow.vue'
import LogDetailModal from '@/modules/dashboard/components/LogSection/LogDetailModal.vue'
import DeleteLogsModal from '@/modules/dashboard/components/LogSection/DeleteLogsModal.vue'
import InfoModal from "@/components/modals/InfoModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"
import SuccessModal from "@/components/modals/SuccessModal.vue"

const clientsStore = useClientsStore()
const { logs } = storeToRefs(clientsStore)

const logDetailModal = ref<InstanceType<typeof LogDetailModal> | null>(null)
const deleteLogsModal = ref<InstanceType<typeof DeleteLogsModal> | null>(null)
const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)
const selectedLog = ref(null)

const search = ref('')
const currentPage = ref(1)
const perPage = 10

// Filtros
const selectedTable = ref('')
const selectedType = ref('')
const selectedUser = ref('')
const startDate = ref('')
const endDate = ref('')

onMounted(refresh)

const uniqueTables = computed(() => [...new Set(logs.value.map(log => log.table).filter(Boolean))])
const uniqueTypes = computed(() => [...new Set(logs.value.map(log => log.type).filter(Boolean))])
const uniqueUsers = computed(() => [...new Set(logs.value.map(log => log.username).filter(Boolean))])

const filteredLogs = computed(() =>
    logs.value.filter(l => {
        const matchesSearch =
            (l.table ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
            (l.type ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
            (l.username ?? '').toLowerCase().includes(search.value.toLowerCase())

        const matchesTable = selectedTable.value === '' || l.table === selectedTable.value
        const matchesType = selectedType.value === '' || l.type === selectedType.value
        const matchesUser = selectedUser.value === '' || l.username === selectedUser.value

        const logDateStr = l.date instanceof Date ? l.date.toISOString().slice(0, 10) : ''
        const matchesStart = !startDate.value || (logDateStr >= startDate.value)
        const matchesEnd = !endDate.value || (logDateStr <= endDate.value)

        return matchesSearch && matchesTable && matchesType && matchesUser && matchesStart && matchesEnd
    })
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

async function refresh() {
    clientsStore.loading = true
    await clientsStore.fecthLogs()
    clientsStore.loading = false
}

async function handleDeleteLogs(date: string) {
    if (date === '') return
    clientsStore.loading = true
    clientsStore.resetMessages()
    await clientsStore.deleteLogs(date)
    if (clientsStore.response?.result) {
        successModal.value?.show(getMessage(`Logs eliminados correctamente hasta la fecha ${date}.`))
        await refresh()
    } else {
        errorModal.value?.show(getMessage('No se pudo eliminar los logs.'))
    }
    clientsStore.loading = false
}

function resetMessages() {
    clientsStore.resetMessages()
}

function getMessage(defaultMsg: string) {
    return clientsStore.response?.message || defaultMsg
}

onUnmounted(() => clientsStore.resetMessages())
</script>

<style scoped>
input[type="date"]::-webkit-calendar-picker-indicator {
    filter: invert(0%) sepia(0%) saturate(0%) hue-rotate(0deg) brightness(0%) contrast(100%);
}
</style>
