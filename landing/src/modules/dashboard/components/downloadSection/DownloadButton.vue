<template>
  <a
    :href="`/${file}`"
    :download="fileName"
    class="btn btn-block border-none bg-primary-500 text-white font-medium rounded-lg shadow hover:bg-primary-600 transition-colors"
  >
    {{ label }}
  </a>
</template>

<script setup lang="ts">
interface Props {
  label: string
  file: string 
  fileName?: string 
}

const props = defineProps<Props>()

// Si no se pasa fileName, usamos el mismo que el archivo
const fileName = props.fileName ?? props.file.split('/').pop()
</script>
