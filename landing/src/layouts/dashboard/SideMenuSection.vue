<template>
  <div class="drawer-side">
    <!-- Overlay para cerrar al tocar fuera -->
    <label for="sidebar" class="drawer-overlay lg:hidden"></label>

    <!-- Sidebar -->
    <aside class="menu p-4 w-70 text-white min-h-full bg-primary-500">
      <div class="flex flex-col mb-6">
        <label for="sidebar" class="ml-auto btn btn-sm btn-ghost lg:hidden hover:bg-primary-400 border-none shadow-2xl">✕</label>
        <div class="flex items-center gap-2">
          <img src="@/assets/logoPrincipal.png" alt="Logo" class="w-20 h-20" />
          <h2 class="text-2xl font-bold">ArchivaCore</h2>
        </div>
      </div>

      <ul>
        <li v-for="item in sidebarItems" :key="item.label">
          <RouterLink
            :to="item.path"
            class="flex items-center gap-2 p-2 rounded-lg hover:bg-primary-400 transition-colors duration-100 ease-in-out"
            active-class="bg-primary-700" 
          >
            <component :is="item.icon" class="w-6 h-6" />
            <span>{{ item.label }}</span>
          </RouterLink>
        </li>
      </ul>
    </aside>
  </div>
</template>

<script setup lang="ts">
import { HomeIcon, CloudArrowDownIcon, Cog6ToothIcon, LifebuoyIcon, CreditCardIcon } from "@heroicons/vue/24/outline";

const sidebarItems = [
  { label: "Inicio", icon: HomeIcon, path: "/dashboard/home" },
  { label: "Descargar App", icon: CloudArrowDownIcon, path: "/dashboard/download" },
  { label: "Configuración", icon: Cog6ToothIcon, path: "/dashboard/settings" },
  { label: "Soporte", icon: LifebuoyIcon, path: "/dashboard/support" },
  { label: "Planes y Facturación", icon: CreditCardIcon, path: "/dashboard/plans" },
];

</script>
