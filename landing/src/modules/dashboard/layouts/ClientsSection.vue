<template>
    <div class="max-w-6xl mx-auto">
        <!-- Título y búsqueda -->
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-2xl font-semibold text-primary-700">Empresas Registradas</h2>
            <div class="input bg-white border-primary-500">
                <MagnifyingGlassIcon class="w-5 text-gray-500" />
                <input v-model="search" type="text" placeholder="Buscar por nombre o correo..." class="w-72" />
            </div>
        </div>

        <!-- Tabla -->
        <div class="overflow-x-auto bg-primary-100 rounded-lg shadow border border-base-content/5">
            <table class="table w-full">
                <thead>
                    <tr class="text-left text-sm text-primary-600 bg-primary-300">
                        <th>Nombre</th>
                        <th>Correo electrónico</th>
                        <th>Plan</th>
                        <th>Fecha de registro</th>
                        <th>Usuarios</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <CompanyRow v-for="company in paginatedCompanies" :key="company.id" :company="company" />
                    <tr v-if="filteredCompanies.length === 0">
                        <td colspan="6" class="text-center py-4 text-gray-400">No se encontraron empresas</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Paginación -->
        <div class="flex justify-end mt-4 gap-2">
            <button class="btn btn-sm bg-primary-500 border-none" :disabled="currentPage === 1" @click="currentPage--">
                <ChevronLeftIcon class="w-4 text-white" />
                Anterior
            </button>
            <button class="btn btn-sm bg-primary-500 border-none" :disabled="currentPage === totalPages"
                @click="currentPage++">
                Siguiente
                <ChevronRightIcon class="w-4 text-white" />
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import CompanyRow from "@/modules/dashboard/components/ClientsSection/CompanyRow.vue";
import { MagnifyingGlassIcon, ChevronLeftIcon, ChevronRightIcon } from "@heroicons/vue/24/outline"

interface Company {
    id: number
    name: string
    email: string
    plan: 'DEMO' | 'PRO'
    registeredAt: string
    users: number
}

const companies = ref<Company[]>([
    { id: 1, name: 'TechNova', email: 'contacto@technova.com', plan: 'DEMO', registeredAt: '2024-01-20', users: 5 },
    { id: 2, name: 'SoftCorp', email: 'admin@softcorp.com', plan: 'PRO', registeredAt: '2024-02-11', users: 12 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    { id: 3, name: 'InnovaSolutions', email: 'soporte@innova.com', plan: 'PRO', registeredAt: '2024-03-01', users: 8 },
    // ...más empresas
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
</script>