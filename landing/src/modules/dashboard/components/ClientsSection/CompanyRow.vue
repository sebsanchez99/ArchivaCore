<!-- CompanyRow.vue -->
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
        <td class="flex gap-2">
            <button @click="$emit('delete', company)" class="btn btn-xs btn-error text-white">Eliminar</button>
            <button @click="$emit('changePassword', company)" class="btn btn-xs btn-outline text-primary-700 hover:bg-primary-500 hover:border-none hover:text-white">
                Cambiar contraseña
            </button>
        </td>
    </tr>
</template>

<script setup lang="ts">
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

defineEmits(['delete', 'changePassword'])
</script>