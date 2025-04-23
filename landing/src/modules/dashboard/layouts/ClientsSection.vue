<template>
    <div class="max-w-6xl mx-auto">
      <!-- Encabezado -->
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 gap-2">
        <h2 class="text-2xl font-semibold text-text-500">Empresas Registradas</h2>
        <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
          <span class="text-sm text-text-300">
            Total: {{ filteredCompanies.length }} empresa{{ filteredCompanies.length === 1 ? '' : 's' }}
          </span>
          <div class="input bg-white border-primary-500 w-full sm:w-auto">
            <MagnifyingGlassIcon class="w-5 text-gray-500" />
            <input
              v-model="search"
              type="text"
              placeholder="Buscar por nombre o correo..."
              class="w-full sm:w-72"
            />
          </div>
        </div>
      </div>
  
      <!-- Tabla -->
      <div class="overflow-x-auto bg-primary-100 rounded-lg shadow border border-base-content/5">
        <table class="table w-full">
          <thead>
            <tr class="text-left text-sm text-text-400 bg-primary-300">
              <th>Nombre</th>
              <th>Correo electrónico</th>
              <th>Plan</th>
              <th>Fecha de registro</th>
              <th>Usuarios</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <CompanyRow
              v-for="company in paginatedCompanies"
              :key="company.id"
              :company="company"
              @delete="openDeleteModal"
              @changePassword="openChangePasswordModal"
            />
            <tr v-if="filteredCompanies.length === 0">
              <td colspan="6" class="text-center py-4 text-gray-400">No se encontraron empresas</td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- Paginación -->
      <div class="flex flex-col sm:flex-row justify-between items-center mt-4 gap-3">
        <span class="text-sm text-gray-500">
          Mostrando {{ startItem + 1 }}–{{ endItem }} de {{ filteredCompanies.length }} empresa{{ filteredCompanies.length === 1 ? '' : 's' }}
        </span>
        <div class="flex justify-between gap-3 ">
          <button
            class="join-item btn btn-sm bg-primary-500 text-white border-none disabled:opacity-50"
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            <ChevronLeftIcon class="w-4" />
            Anterior
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
  
      <!-- Modal Eliminar -->
      <dialog ref="deleteModal" class="modal">
        <div class="modal-box bg-white">
          <h3 class="font-semibold text-lg text-text-400">Eliminar empresa</h3>
          <p class="py-2 text-text-300 text-sm">
            ¿Está seguro de que desea eliminar la empresa <strong>{{ selectedCompany?.name }}</strong>? Esta acción no se
            puede deshacer.
          </p>
          <p class="alert text-sm text-red-400 bg-white border-red-400 shadow-sm">
            <ExclamationCircleIcon class="w-6 inline-block mr-2" />
            Al eliminar esta empresa, se eliminarán todos los datos asociados, incluyendo usuarios, archivos y
            configuraciones. Los usuarios no podrán acceder a la plataforma.
          </p>
          <div class="modal-action">
            <form method="dialog" class="space-x-2">
              <button class="btn btn-outline text-primary-500 hover:bg-primary-400 hover:border-none hover:text-white">
                Cancelar
              </button>
              <button class="btn btn-error text-white">Eliminar empresa</button>
            </form>
          </div>
        </div>
      </dialog>
  
      <!-- Modal Cambiar Contraseña -->
      <dialog ref="changePasswordModal" class="modal">
        <div class="modal-box bg-white">
          <h3 class="font-semibold text-lg text-text-500">Cambiar contraseña</h3>
          <p class="py-2 text-text-300 text-sm">
            Establecer nueva contraseña para la empresa <strong>{{ selectedCompany?.name }}</strong>.
          </p>
          <form class="space-y-4">
            <div class="form-control">
              <label for="new-password" class="label text-sm">Nueva contraseña</label>
              <input type="password" id="new-password" class="input bg-white border-primary-500 w-full" required />
            </div>
            <div class="form-control">
              <label for="confirm-password" class="label text-sm">Confirmar nueva contraseña</label>
              <input type="password" id="confirm-password" class="input bg-white border-primary-500 w-full" required />
            </div>
          </form>
          <p class="mt-3 text-sm text-text-300">
            La nueva contraseña será enviada al correo electrónico principal de la empresa:
            {{ selectedCompany?.email }}
          </p>
          <div class="modal-action">
            <form method="dialog" class="space-x-2">
              <button class="btn btn-outline text-primary-500 hover:bg-primary-400 hover:border-none hover:text-white">
                Cancelar
              </button>
              <button class="btn border-none bg-primary-500 text-white hover:bg-primary-400">
                <LockClosedIcon class="w-4 mr-2" />
                Cambiar contraseña
              </button>
            </form>
          </div>
        </div>
      </dialog>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, computed } from 'vue'
  import CompanyRow from "@/modules/dashboard/components/ClientsSection/CompanyRow.vue"
  import {
    MagnifyingGlassIcon,
    ChevronLeftIcon,
    ChevronRightIcon,
    ExclamationCircleIcon,
    LockClosedIcon
  } from "@heroicons/vue/24/outline"
  
  interface Company {
    id: number
    name: string
    email: string
    plan: 'DEMO' | 'PRO'
    registeredAt: string
    users: number
  }
  
  const deleteModal = ref<HTMLDialogElement | null>(null)
  const changePasswordModal = ref<HTMLDialogElement | null>(null)
  const selectedCompany = ref<Company | null>(null)
  
  function openDeleteModal(company: Company) {
    selectedCompany.value = company
    deleteModal.value?.showModal()
  }
  
  function openChangePasswordModal(company: Company) {
    selectedCompany.value = company
    changePasswordModal.value?.showModal()
  }
  
  const companies = ref<Company[]>([
    { id: 1, name: 'TechNova', email: 'contacto@technova.com', plan: 'DEMO', registeredAt: '2024-01-20', users: 5 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    // Puedes duplicar más datos para probar
  ])
  
  const search = ref('')
  const currentPage = ref(1)
  const perPage = 10
  
  const filteredCompanies = computed(() =>
    companies.value.filter(c =>
      c.name.toLowerCase().includes(search.value.toLowerCase()) ||
      c.email.toLowerCase().includes(search.value.toLowerCase())
    )
  )
  
  const totalPages = computed(() =>
    Math.ceil(filteredCompanies.value.length / perPage)
  )
  
  const paginatedCompanies = computed(() => {
    const start = (currentPage.value - 1) * perPage
    return filteredCompanies.value.slice(start, start + perPage)
  })
  
  const startItem = computed(() => (currentPage.value - 1) * perPage)
  const endItem = computed(() => {
    const end = startItem.value + paginatedCompanies.value.length
    return end > filteredCompanies.value.length ? filteredCompanies.value.length : end
  })
  </script>
  