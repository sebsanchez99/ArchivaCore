<template>
  <div class="max-w-8xl mx-auto">
    <div v-if="clientsStore.loading" class="flex justify-center items-center h-64">
      <span class="loading loading-spinner loading-lg text-primary-500"></span>
    </div>
    <div v-else>
      <!-- Encabezado -->
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 gap-2">
        <h2 class="text-2xl font-semibold text-text-500">Usuarios Administradores</h2>
        <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
          <span class="text-sm text-text-300">
            Total: {{ filteredUsers.length }} usuario{{ filteredUsers.length === 1 ? '' : 's' }}
          </span>
          <div class="input bg-white border-primary-500 w-full sm:w-auto">
            <input v-model="search" type="text" placeholder="Buscar por nombre o rol..." class="w-full sm:w-72" />
          </div>
          <button class="btn btn-sm bg-primary-500 text-white border-none" @click="openCreateModal('Superusuario')">
            Crear superusuario
          </button>
          <button class="btn btn-sm bg-primary-500 text-white border-none" @click="openCreateModal('Asesor')">
            Crear usuario soporte
          </button>
        </div>
      </div>
      <!-- Tabla -->
      <div class="overflow-x-auto bg-primary-100 rounded-lg shadow border border-base-content/5">
        <table class="table w-full">
          <thead>
            <tr class="text-left text-sm text-text-400 bg-primary-300">
              <th>Nombre</th>
              <th>Nombre completo</th>
              <th>Rol</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in paginatedUsers" :key="user.id">
              <td>{{ user.name }}</td>
              <td>{{ user.fullname }}</td>
              <td>
                <span :class="user.roleName && user.roleName.toLowerCase() === 'superusuario'
                  ? 'badge bg-purple-400 border-none text-white font-semibold'
                  : 'badge bg-cyan-400 border-none text-white font-semibold'">
                  {{ user.roleName }}
                </span>
              </td>

              <td>
                <span :class="user.active
                  ? 'badge bg-green-400 text-white border-none'
                  : 'badge bg-gray-400 text-white border-none'">
                  {{ user.active ? 'Activo' : 'Inactivo' }}
                </span>
              </td>
              <td>
                <div class="flex flex-col sm:flex-row flex-wrap gap-2">
                  <button @click="openEditModal(user)"
                    class="btn btn-xs bg-blue-500 text-white border-none">Editar</button>
                  <button @click="openChangeStateModal(user)" :class="user.active
                    ? 'btn btn-xs bg-yellow-500 text-white hover:bg-yellow-600 border-none'
                    : 'btn btn-xs bg-green-500 text-white hover:bg-green-600 border-none'">
                    {{ user.active ? 'Desactivar' : 'Activar' }}
                  </button>
                  <button @click="openDeleteModal(user)" class="btn btn-xs btn-error text-white">Eliminar</button>
                </div>
              </td>
            </tr>
            <tr v-if="filteredUsers.length === 0">
              <td colspan="5" class="text-center py-4 text-gray-400">No se encontraron usuarios</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- Paginación -->
      <div class="flex flex-col sm:flex-row justify-between items-center mt-4 gap-3">
        <span class="text-sm text-gray-500">
          Mostrando {{ startItem + 1 }}–{{ endItem }} de {{ filteredUsers.length }} usuario{{ filteredUsers.length === 1
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

    <!-- Modales -->
    <InfoModal ref="deleteModal" :title="'Eliminar usuario'"
      :message="`¿Está seguro de que desea eliminar el usuario ${selectedUser?.name}? Esta acción no se puede deshacer.`"
      :onConfirmAction="handleDeleteUser" :onCancelAction="handleCancel" />

    <InfoModal ref="changeStateModal" :title="'Cambiar estado de usuario'"
      :message="`¿Está seguro de que desea ${changeStateText(selectedUser?.active)} el usuario ${selectedUser?.name}?`"
      :onConfirmAction="handleChangeStateUser" :onCancelAction="handleCancel" />

    <UserEditModal ref="editModal" :user="selectedUser" @saved="handleUserSaved" />
    <UserCreateModal ref="createModal" :role="createRole" @created="handleUserCreated" />

    <SuccessModal ref="successModal" @close="resetMessages" />
    <ErrorModal ref="errorModal" @close="resetMessages" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useClientsStore } from '@/stores/clientsStore'
import InfoModal from "@/components/modals/InfoModal.vue"
import SuccessModal from "@/components/modals/SuccessModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"
import UserEditModal from '@/modules/dashboard/components/UsersSection/UserEditModal.vue'
import UserCreateModal from '@/modules/dashboard/components/UsersSection/UserCreateModal.vue'
import type { AdminUser } from '@/interfaces/adminUser'

const clientsStore = useClientsStore()
const { adminUsers } = storeToRefs(clientsStore)

const deleteModal = ref<InstanceType<typeof InfoModal> | null>(null)
const changeStateModal = ref<InstanceType<typeof InfoModal> | null>(null)
const editModal = ref<InstanceType<typeof UserEditModal> | null>(null)
const createModal = ref<InstanceType<typeof UserCreateModal> | null>(null)
const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)

const selectedUser = ref<AdminUser | null>(null)
const createRole = ref<'Superusuario' | 'Asesor'>('Superusuario')
const search = ref('')
const currentPage = ref(1)
const perPage = 10

onMounted(refresh)

async function refresh() {
  clientsStore.loading = true
  await clientsStore.getAdminUsers()
  clientsStore.loading = false
}

function openDeleteModal(user: AdminUser) {
  selectedUser.value = user
  deleteModal.value?.open()
}

function openChangeStateModal(user: AdminUser) {
  selectedUser.value = user
  changeStateModal.value?.open()
}

function openEditModal(user: AdminUser) {
  selectedUser.value = user
  editModal.value?.open(user)
}

function openCreateModal(role: 'Superusuario' | 'Asesor') {
  createRole.value = role
  createModal.value?.open()
}

async function handleDeleteUser() {
  if (!selectedUser.value) return
  clientsStore.loading = true
  await clientsStore.deleteAdminUser(selectedUser.value.id)
  if (clientsStore.response?.result) {
    successModal.value?.show(getMessage('Usuario eliminado correctamente.'))
    await refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo eliminar el usuario.'))
  }
  clientsStore.resetMessages()
  clientsStore.loading = false
  selectedUser.value = null
}

async function handleChangeStateUser() {
  if (!selectedUser.value) return
  clientsStore.loading = true
  const newState = !selectedUser.value.active
  await clientsStore.changeStateAdminUser(selectedUser.value.id, newState)
  if (clientsStore.response?.result) {
    successModal.value?.show(getMessage('Estado del usuario actualizado correctamente.'))
    await refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo cambiar el estado del usuario.'))
  }
  clientsStore.resetMessages()
  clientsStore.loading = false
  selectedUser.value = null
}

function handleCancel() {
  selectedUser.value = null
}

function changeStateText(state?: boolean) {
  return state ? 'desactivar' : 'activar'
}

function resetMessages() {
  clientsStore.resetMessages()
}

async function handleUserSaved() {
  if (!selectedUser.value) return
  clientsStore.loading = true
  const result = clientsStore.response?.result
    if (result) {
    successModal.value?.show(getMessage('Usuario actualizado con éxito.'))
    refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo actualizar la información del usuario.'))
  }
  clientsStore.loading = false
  selectedUser.value = null
  clientsStore.resetMessages()
}

async function handleUserCreated() {
  clientsStore.loading = true
  const result = clientsStore.response?.result
  if (result) {
    successModal.value?.show(getMessage('Usuario creado con éxito.'))
    refresh()
  } else {
    errorModal.value?.show(getMessage('No se pudo crear el usuario.'))
  }
  clientsStore.loading = false
  selectedUser.value = null
  clientsStore.resetMessages()
}

function getMessage(defaultMsg: string) {
  return clientsStore.response?.message || defaultMsg
}

const filteredUsers = computed(() =>
  adminUsers.value.filter(u =>
    (u.name ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
    (u.fullname ?? '').toLowerCase().includes(search.value.toLowerCase()) ||
    (u.roleName ?? '').toLowerCase().includes(search.value.toLowerCase())
  )
)

const totalPages = computed(() => Math.ceil(filteredUsers.value.length / perPage))

const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filteredUsers.value.slice(start, start + perPage)
})

const startItem = computed(() => (currentPage.value - 1) * perPage)
const endItem = computed(() => startItem.value + paginatedUsers.value.length)
</script>