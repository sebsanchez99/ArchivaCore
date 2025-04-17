<template>
    <tr>
        <td class="py-3">{{ company.name }}</td>
        <td>{{ company.email }}</td>
        <td>
            <span :class="company.plan === 'PRO' ? 'badge bg-purple-400 border-none' : 'badge bg-blue-400 border-none'">
                {{ company.plan }}
            </span>
        </td>
        <td>{{ company.registeredAt }}</td>
        <td>{{ company.users }}</td>
        <td class="space-x-2">
            <button @click="openModal" class="btn btn-xs btn-error text-white">Eliminar</button>
  
        </td>

        <!-- Modal -->
        <dialog ref="modal" class="modal">
            <div class="modal-box bg-white">
                <h3 class="font-bold text-lg text-primary-700">Eliminar empresa</h3>
                <p class="py-2 text-primary-500">
                    ¿Está seguro de que desea eliminar la empresa <strong>{{ company.name }}</strong>? Esta acción no se
                    puede deshacer.
                </p>
                <p class="alert text-sm text-red-400 bg-white border-red-400 shadow-sm">
                    <ExclamationCircleIcon class="w-6 inline-block mr-2" />
                    Al eliminar esta empresa, se eliminarán todos los datos asociados, incluyendo usuarios, archivos y
                    configuraciones.
                    Los usuarios no podrán acceder a la plataforma.
                </p>
                <div class="modal-action">
                    <form method="dialog" class="space-x-2">
                        <button class="btn btn-outline text-primary-500 hover:bg-primary-400 hover:border-none hover:text-white">Cancelar</button>
                        <button class="btn btn-error text-white">Eliminar empresa</button>
                    </form>
                </div>
            </div>
        </dialog>
    </tr>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ExclamationCircleIcon } from "@heroicons/vue/24/outline"


const modal = ref<HTMLDialogElement | null>(null)

function openModal() {
    modal.value?.showModal()
}

defineProps<{
    company: {
        id: number
        name: string
        email: string
        plan: string
        registeredAt: string
        users: number
    }
}>()
</script>