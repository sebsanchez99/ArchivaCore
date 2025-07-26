<template>
  <div class="max-w-8xl mx-auto">
    <!-- Encabezado -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 gap-2">
      <h2 class="text-2xl font-semibold text-text-500">Empresas Registradas</h2>
      <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
        <span class="text-sm text-text-300">
          Total: {{ filteredCompanies.length }} empresa{{ filteredCompanies.length === 1 ? '' : 's' }}
        </span>
        <div class="input bg-white border-primary-500 w-full sm:w-auto">
          <MagnifyingGlassIcon class="w-5 text-gray-500" />
          <input v-model="search" type="text" placeholder="Buscar por nombre o correo..." class="w-full sm:w-72" />
        </div>
      </div>
    </div>

    <!-- Tabla -->
    <div class="overflow-x-auto bg-primary-100 rounded-lg shadow border border-base-content/5">
      <table class="table w-full">
        <thead>
          <tr class="text-left text-sm text-text-400 bg-primary-300">
            <th>Empresa</th>
            <th>Representante</th>
            <th>Correo electrónico</th>
            <th>Plan</th>
            <th>Fecha de inicio</th>
            <th>Registro</th>
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <CompanyRow
            v-for="client in paginatedCompanies"
            :key="client.id"
            :client="client"
            @delete="openDeleteModal"
            @changePassword="openChangePasswordModal"
            @toggleStatus="openChangeStateModal"
          />
          <tr v-if="filteredCompanies.length === 0">
            <td colspan="8" class="text-center py-4 text-gray-400">No se encontraron empresas</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Paginación -->
    <div class="flex flex-col sm:flex-row justify-between items-center mt-4 gap-3">
      <span class="text-sm text-gray-500">
        Mostrando {{ startItem + 1 }}–{{ endItem }} de {{ filteredCompanies.length }} empresa{{ filteredCompanies.length === 1 ? '' : 's' }}
      </span>
      <div class="flex justify-between gap-3">
        <button
          class="join-item btn btn-sm bg-primary-500 text-white border-none disabled:opacity-50"
          :disabled="currentPage === 1"
          @click="currentPage--"
        >
          <ChevronLeftIcon class="w-4" /> Anterior
        </button>
        <button
          class="join-item btn btn-sm bg-primary-500 text-white border-none disabled:opacity-50"
          :disabled="currentPage === totalPages"
          @click="currentPage++"
        >
          Siguiente
          <ChevronRightIcon class="w-4" />
        </button>
      </div>
    </div>

    <!-- Modales -->
    <InfoModal
      ref="deleteModal"
      :title="`Eliminar empresa`"
      :message="`¿Está seguro de que desea eliminar la empresa ${selectedCompany?.name}? Esta acción no se puede deshacer.`"
      :alertMessage="`Al eliminar esta empresa, se eliminarán todos los datos asociados, incluyendo usuarios, archivos y configuraciones.`"
      :onConfirmAction="handleDeleteCompany"
      :onCancelAction="handleCancel"
    />

    <InfoModal
      ref="changeStateModal"
      :title="`Cambiar estado de empresa`"
      :message="`¿Está seguro de que desea ${changeStateText(selectedCompany?.active)} la empresa ${selectedCompany?.name}? Esta acción no se puede deshacer.`"
      :onConfirmAction="handleChangeStateCompany"
      :onCancelAction="handleCancel"
    />

    <ChangePasswordModal ref="changePasswordModal" :company="selectedCompany" @passwordChanged="handleChangePassword" />

    <SuccessModal ref="successModal" @close="resetMessages" />
    <ErrorModal ref="errorModal" @close="resetMessages" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useClientsStore } from '@/stores/clientsStore'

import InfoModal from "@/components/modals/InfoModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"
import SuccessModal from "@/components/modals/SuccessModal.vue"
import CompanyRow from '@/modules/dashboard/components/ClientsSection/CompanyRow.vue'
import ChangePasswordModal from '@/modules/dashboard/components/ClientsSection/ChangePasswordModal.vue'

import {
  MagnifyingGlassIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
} from '@heroicons/vue/24/outline'

import type { Client } from '@/interfaces/client'

const clientsStore = useClientsStore()
const { clients } = storeToRefs(clientsStore)

const deleteModal = ref<InstanceType<typeof InfoModal> | null>(null)
const changeStateModal = ref<InstanceType<typeof InfoModal> | null>(null)
const changePasswordModal = ref<InstanceType<typeof ChangePasswordModal> | null>(null)
const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)

const selectedCompany = ref<Client | null>(null)
const search = ref('')
const currentPage = ref(1)
const perPage = 10

onMounted(refresh)

async function refresh() {
  clientsStore.loading = true
  await clientsStore.fetchClients()
  clientsStore.loading = false
}

function openDeleteModal(company: Client) {
  selectedCompany.value = company
  deleteModal.value?.open()
}

function openChangePasswordModal(company: Client) {
  selectedCompany.value = company
  changePasswordModal.value?.open()
}

function openChangeStateModal(company: Client) {
  selectedCompany.value = company
  changeStateModal.value?.open()
}

async function handleDeleteCompany() {
  if (!selectedCompany.value) return

  clientsStore.resetMessages()
  await clientsStore.deleteCompany(selectedCompany.value.id)

  if (clientsStore.response?.result) {
    successModal.value?.show(getMessage('Empresa eliminada correctamente.'))
    await refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo eliminar la empresa.'))
  }

  selectedCompany.value = null
}

async function handleChangeStateCompany() {
  if (!selectedCompany.value) return

  clientsStore.resetMessages()
  const newState = !selectedCompany.value.active
  await clientsStore.changeUserStatus(selectedCompany.value.id, newState)

  if (clientsStore.response?.result) {
    successModal.value?.show(getMessage(`Empresa ${newState ? 'activada' : 'desactivada'} correctamente.`))
    await refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo cambiar el estado de la empresa.'))
  }

  selectedCompany.value = null
}

async function handleChangePassword() {
  if (!selectedCompany.value) return

  const result = await changePasswordModal.value?.submit()
  
  if (result) {
    successModal.value?.show(getMessage('Contraseña cambiada correctamente.'))
  } else {
    errorModal.value?.show(getMessage('No se pudo cambiar la contraseña.'))
  }

  selectedCompany.value = null
}

function handleCancel() {
  selectedCompany.value = null
}

function changeStateText(state?: boolean) {
  return state ? 'desactivar' : 'activar'
}

function getMessage(defaultMsg: string) {
  return clientsStore.response?.message || defaultMsg
}

function resetMessages() {
  clientsStore.resetMessages()
}

const filteredCompanies = computed(() =>
  clients.value.filter(c =>
    c.name.toLowerCase().includes(search.value.toLowerCase()) ||
    c.email.toLowerCase().includes(search.value.toLowerCase())
  )
)

const totalPages = computed(() => Math.ceil(filteredCompanies.value.length / perPage))

const paginatedCompanies = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filteredCompanies.value.slice(start, start + perPage)
})

const startItem = computed(() => (currentPage.value - 1) * perPage)
const endItem = computed(() => startItem.value + paginatedCompanies.value.length)
</script>
