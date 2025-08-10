<template>
  <div>
    <!-- Encabezado -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-text-800 flex items-center gap-2">
        <LightBulbIcon class="w-6 h-6 text-primary-500" />
        Centro de Ayuda del Asesor
      </h1>
      <p class="text-text-500 text-sm ml-2">
        Encuentra aquí respuestas rápidas y guías básicas para manejar ArchivaCore y resolver dudas frecuentes.
      </p>
    </div>

    <!-- Buscador -->
    <div class="mb-6">
      <input
        v-model="search"
        type="text"
        placeholder="🔍 Buscar en la ayuda..."
        class="w-full border border-primary-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary-400"
      />
    </div>

    <!-- Acordeón de secciones -->
    <div
      v-for="section in sections"
      :key="section.title"
      class="mb-4 border border-primary-100 rounded-lg shadow-sm"
    >
      <button
        @click="toggle(section)"
        class="flex items-center justify-between w-full p-4 text-left font-semibold text-primary-700 hover:bg-primary-50"
      >
        <span class="flex items-center gap-2">
          <component :is="section.icon" class="w-5 h-5 text-primary-500" />
          {{ section.title }}
        </span>
        <span class="cursor-pointer">
          <ChevronDownIcon v-if="section.open" class="w-5 h-5 text-primary-400" />
          <ChevronRightIcon v-else class="w-5 h-5 text-primary-400" />
        </span>
      </button>
      <transition name="fade">
        <ul
          v-if="section.open"
          class="p-4 space-y-2 text-sm text-text-600 border-t border-primary-100 bg-white"
        >
          <li
            v-for="item in section.filteredItems"
            :key="item"
            class="flex items-start gap-2"
          >
            <span class="text-primary-500">•</span>
            <span>{{ item }}</span>
          </li>
          <li
            v-if="section.filteredItems.length === 0"
            class="text-text-400 italic"
          >
            No se encontraron resultados
          </li>
        </ul>
      </transition>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import {
  BookOpenIcon,
  QuestionMarkCircleIcon,
  LightBulbIcon,
  ChevronDownIcon,
  ChevronRightIcon
} from '@heroicons/vue/24/outline'

const search = ref('')

const guides = [
  'Iniciar y cerrar sesión de forma segura.',
  'Restablecer contraseña desde el perfil de usuario.',
  'Buscar documentos por nombre, fecha o parámetros.',
  'Revisar notificaciones para cambios importantes.',
  'Usar el chat de soporte para contactar al equipo técnico.'
]

const faq = [
  'No puedo iniciar sesión → Verifica usuario y contraseña o contacta soporte.',
  'Eliminé un documento por error → Revisa el área de reciclaje o solicita restauración.',
  'No veo cierta opción en el menú → Puede ser por permisos de rol, consulta con un administrador.',
  '“Límite de usuarios excedido” → Actualiza el plan de la organización.',
  '“Límite de almacenamiento alcanzado” → Elimina archivos o amplía el plan.',
  'No puedo descargar un archivo → El sistema lo escanea antes; si falla, revisa con soporte.',
  'No encuentro un documento → Usa búsqueda avanzada o revisa si fue movido por reglas.',
  'El sistema va lento → Verifica conexión y recursos del equipo.',
  'No entiendo una notificación → Haz clic sobre ella para más detalles.'
]

const tips = [
  'Mantén carpetas organizadas siguiendo las reglas del sistema.',
  'Usa criterios de búsqueda específicos para ahorrar tiempo.',
  'Revisa esta sección antes de contactar soporte.',
  'Mantén tus credenciales seguras y no compartas tu cuenta.'
]

const sections = reactive([
  {
    title: 'Guías rápidas',
    icon: BookOpenIcon,
    items: guides,
    open: true,
    filteredItems: computed(() =>
      guides.filter(g => g.toLowerCase().includes(search.value.toLowerCase()))
    )
  },
  {
    title: 'Preguntas frecuentes',
    icon: QuestionMarkCircleIcon,
    items: faq,
    open: false,
    filteredItems: computed(() =>
      faq.filter(f => f.toLowerCase().includes(search.value.toLowerCase()))
    )
  },
  {
    title: 'Consejos',
    icon: LightBulbIcon,
    items: tips,
    open: false,
    filteredItems: computed(() =>
      tips.filter(t => t.toLowerCase().includes(search.value.toLowerCase()))
    )
  }
])

function toggle(section: any) {
  section.open = !section.open
}
</script>

