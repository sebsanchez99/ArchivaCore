<template>
  <div class="drawer-side">
    <label for="sidebar" class="drawer-overlay lg:hidden border"></label>

    <aside class="menu p-4 w-70 text-white min-h-full bg-primary-500 border-r border-primary-100 flex flex-col justify-between">
      <div>
        <div class="flex flex-col">
          <label for="sidebar" class="ml-auto btn btn-sm btn-ghost lg:hidden hover:bg-primary-400 border-none shadow-2xl">✕</label>
          <div class="flex items-center gap-2">
            <img src="@/assets/logoPrincipal.png" alt="Logo" class="w-15" />
            <h2 class="text-2xl font-bold">ArchivaCore</h2>
          </div>
        </div>

        <div class="divider before:bg-primary-100 after:bg-primary-100"></div>

        <ul>
          <li v-for="item in sidebarItems" :key="item.label" >
            <RouterLink
              :to="item.path"
              class="btn btn-ghost flex items-center justify-start hover:bg-primary-400 border-none hover:shadow-2xl"
              active-class="bg-primary-700"
            >
              <component :is="item.icon" class="w-5" />
              <span>{{ item.label }}</span>
            </RouterLink>
          </li>
        </ul>
      </div>

      <!-- Pie con usuario y botón cerrar sesión -->
      <div class="mt-6  pt-4">
        <div class="mb-2">
          <p class="text-sm font-semibold">Usuario Demo</p>
          <p class="text-xs text-primary-200">usuario@empresa.com</p>
        </div>
        <button
          class="btn btn-sm btn-outline text-white border-white hover:bg-primary-400 w-full flex items-center justify-center gap-2"
          @click="cerrarSesion"
        >
          <ArrowLeftEndOnRectangleIcon class="w-5 h-5" />
          Cerrar sesión
        </button>
      </div>
    </aside>
  </div>
</template>

<script setup lang="ts">
import {
  HomeIcon,
  CloudArrowDownIcon,
  Cog6ToothIcon,
  LifebuoyIcon,
  CreditCardIcon,
  ArrowLeftEndOnRectangleIcon,
  UserIcon, 
  ChatBubbleLeftRightIcon
} from "@heroicons/vue/24/outline";

const sidebarItems = [
  { label: "Inicio", icon: HomeIcon, path: "/dashboard/home" },
  { label: "Descargar App", icon: CloudArrowDownIcon, path: "/dashboard/download" },
  { label: "Soporte", icon: LifebuoyIcon, path: "/dashboard/support" },
  { label: "Planes y Facturación", icon: CreditCardIcon, path: "/dashboard/plans" },
  { label: "Soporte Clientes", icon: ChatBubbleLeftRightIcon, path: "/dashboard/chat" },
  { label: "Clientes", icon: UserIcon, path: "/dashboard/clients" },
  { label: "Configuración", icon: Cog6ToothIcon, path: "/dashboard/settings" },
];

const cerrarSesion = () => {
  // Aquí va la lógica real de cerrar sesión
  console.log("Sesión cerrada");
};
</script>
