<template>
    <tr>
        <!-- Empresa -->
        <td class="py-3">{{ client.name }}</td>

        <!-- Representante -->
        <td>{{ client.fullname }}</td>

        <!-- Correo electrónico -->
        <td>{{ client.email }}</td>

        <!-- Plan -->
        <td>
            <span :class="client.planName === 'PRO'
                ? 'badge bg-purple-400 border-none text-white font-semibold'
                : 'badge bg-blue-400 border-none text-white font-semibold'">
                {{ client.planName }}
            </span>
        </td>

        <!-- Fecha de inicio -->
        <td>{{ formatDate(client.initialDate) }}</td>

        <!-- Fecha de registro -->
        <td>{{ formatDate(client.registerDate) }}</td>

        <!-- Estado -->
        <td>
            <span :class="client.active
                ? 'badge bg-green-400 text-white border-none'
                : 'badge bg-gray-400 text-white border-none'">
                {{ client.active ? 'Activa' : 'Inactiva' }}
            </span>
        </td>

        <!-- Acciones -->
        <td>
            <div class="flex flex-col sm:flex-row flex-wrap gap-2">
                <button @click="$emit('delete', client)" class="btn btn-xs btn-error text-white">
                    Eliminar
                </button>

                <button @click="$emit('changePassword', client)"
                    class="btn btn-xs text-white hover:bg-primary-600 hover:border-none bg-primary-500 border-none">
                    Cambiar contraseña
                </button>

                <button @click="$emit('toggleStatus', client)" :class="client.active
                    ? 'btn btn-xs bg-yellow-500 text-white hover:bg-yellow-600 border-none'
                    : 'btn btn-xs bg-green-500 text-white hover:bg-green-600 border-none'">
                    {{ client.active ? 'Desactivar' : 'Activar' }}
                </button>
            </div>
        </td>

    </tr>
</template>

<script setup lang="ts">
import type { Client } from '@/interfaces/client'

defineProps<{ client: Client }>()
defineEmits(['delete', 'changePassword', 'toggleStatus'])

function formatDate(date: Date): string {
    return new Date(date).toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    })
}
</script>
