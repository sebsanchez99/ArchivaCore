<template>
  <tr>
    <td>{{ log.table }}</td>
    <td>{{ log.type }}</td>
    <td>{{ log.description }}</td>
    <td>{{ log.date }}</td>
    <td>{{ log.username || 'Desconocido' }}</td>
    <td>
      <button class="btn btn-sm bg-cyan-500 text-white border-none" @click="$emit('viewDetail', log)">
        Ver detalles
      </button>
    </td>
  </tr>
</template>

<script setup lang="ts">
import type { Log } from '@/interfaces/log'
defineProps<{ log: Log }>()
defineEmits(['viewDetail'])

</script>