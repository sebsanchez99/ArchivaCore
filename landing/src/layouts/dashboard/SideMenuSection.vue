<template>
  <div class="drawer lg:drawer-open">
    <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
    
    <!-- Contenido Principal -->
    <div class="drawer-content flex flex-col justify-start">
      <label for="my-drawer-2" class="drawer-button lg:hidden">
        <Bars3Icon class="btn" />
      </label>
    </div>

    <!-- Sidebar -->
    <div class="drawer-side">
      <label for="my-drawer-2" aria-label="Cerrar Sidebar" class="drawer-overlay"></label>
      <ul 
        :class="['menu text-base-content min-h-full p-4 bg-primary-500 transition-all duration-300 ease-in-out', isCompact ? 'w-20' : 'w-64']">
        
        <!-- Encabezado del Sidebar -->
        <div class="mb-5 mt-1 flex justify-between items-center">
          <img :class="isCompact ? 'w-10' : 'w-20'" src="@/assets/logo.png" alt="Logo">
          <button @click="toggleCompact" class="btn btn-sm btn-ghost" aria-label="Alternar Sidebar">
            <Bars3Icon class="w-6 h-6" />
          </button>
        </div>

        <!-- Elementos del Sidebar -->
        <li v-for="item in sidebarItems" :key="item.label"
          class="cursor-pointer flex flex-row items-center space-x-2 p-2 rounded-lg hover:bg-primary-600 transition-all duration-300 ease-in-out">
          <component :is="item.icon" class="w-8 h-8 p-0 stroke-black pointer-events-none" />
          <span v-show="!isCompact" class="pointer-events-none">
            {{ item.label }}
          </span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { Bars3Icon, HomeIcon, UserIcon } from "@heroicons/vue/24/outline";

const isCompact = ref(false);

// Menú del Sidebar
const sidebarItems = ref([
  { label: "Inicio", icon: HomeIcon },
  { label: "Usuarios", icon: UserIcon },
  { label: "Configuración", icon: Bars3Icon },
]);

// Alternar tamaño del Sidebar
function toggleCompact() {
  isCompact.value = !isCompact.value;
}

// Detectar tamaño de pantalla
function handleResize() {
  isCompact.value = window.innerWidth < 1024;
}

onMounted(() => {
  window.addEventListener("resize", handleResize);
  handleResize();
});

onUnmounted(() => {
  window.removeEventListener("resize", handleResize);
});
</script>
