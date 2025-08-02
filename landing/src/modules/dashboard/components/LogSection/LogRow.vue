<template>
  <tr>
    <td>{{ log.table }}</td>
    <td>{{ log.type }}</td>
    <td>{{ log.description }}</td>
    <td>{{ log.date }}</td>
    <td>{{ log.username || 'Desconocido' }}</td>
    <td>
      <button class="btn btn-xs bg-primary-500 text-white" @click="$emit('viewDetail', log)">
        Ver detalle
      </button>
    </td>
  </tr>
</template>

<script setup lang="ts">
import type { Log } from '@/interfaces/log'
defineProps<{ log: Log }>()
defineEmits(['viewDetail'])

</script>