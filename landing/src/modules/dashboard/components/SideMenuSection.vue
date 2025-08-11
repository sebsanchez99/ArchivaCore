<template>
  <div class="drawer-side">
    <label for="sidebar" class="drawer-overlay lg:hidden border"></label>

    <aside
      class="menu p-4 w-70 text-white min-h-full bg-primary-500 border-r border-primary-100 flex flex-col justify-between">
      <div>
        <div class="flex flex-col mb-8">
          <label for="sidebar"
            class="ml-auto btn btn-sm btn-ghost lg:hidden hover:bg-primary-400 border-none shadow-2xl">✕</label>
          <div class="flex items-center gap-2">
            <img src="@/assets/logoPrincipal.png" alt="Logo" class="w-15" />
            <h2 class="text-2xl font-semibold ">ArchivaCore</h2>
          </div>
        </div>

        <ul>
          <li v-for="item in sidebarItems" :key="item.label">
            <RouterLink :to="item.path"
              class="btn btn-ghost flex items-center justify-start gap-2 border-none transition-all duration-300 group hover:shadow hover:bg-primary-600"
              active-class="bg-primary-600">
              <component :is="item.icon"
                class="w-5 h-5 mr-2 transition-opacity duration-300 hover:text-primary-800 opacity-70" />
              <span class="text-white font-medium transition-opacity duration-300">
                {{ item.label }}
              </span>

              <!-- Badge si hay mensajes sin leer -->
              <span v-if="(item.label === 'Soporte Clientes' || item.label === 'Soporte') && unreadSupportMessages > 0"
                class="ml-auto bg-indigo-200 text-indigo-800 text-xs font-semibold px-2 py-0.5 rounded-full">
                {{ unreadSupportMessages }}
              </span>

            </RouterLink>
          </li>

        </ul>
      </div>

      <!-- Pie con usuario y botón cerrar sesión -->
      <div class="mt-6  pt-4 text-white">
        <div class="mb-2">
          <p class="text-sm font-semibold">{{ fullname }}</p>
          <p class="text-xs">{{ email }}</p>
        </div>
        <RouterLink to="/"
          class="btn btn-sm  bg-primary-700 text-white border-none hover:bg-primary-800 shadow w-full flex items-center justify-center gap-2"
          @click="cerrarSesion">
          <ArrowLeftEndOnRectangleIcon class="w-5 h-5" />
          Cerrar sesión
        </RouterLink>
      </div>
    </aside>
  </div>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { 
  HomeIcon,
  CloudArrowDownIcon,
  Cog6ToothIcon,
  LifebuoyIcon,
  CreditCardIcon,
  ArrowLeftEndOnRectangleIcon,
  UserIcon,
  UsersIcon,
  ChatBubbleLeftRightIcon,
  ClipboardDocumentListIcon, 
  QuestionMarkCircleIcon
} from "@heroicons/vue/24/solid";

import { useAuthStore } from "@/stores/authStore";
import { useChatStore } from "@/stores/chatStore";

const chatStore = useChatStore();
const authStore = useAuthStore();

const fullname = computed(() => authStore.getFullname || "Usuario Demo");
const email = computed(() => authStore.getEmail || "");

const unreadSupportMessages = computed(() => {
  if (rol === "empresa") {
    return chatStore.unreadMessages[authStore.getCompanyId] || 0;
  }
  return Object.values(chatStore.unreadMessages).filter(v => v > 0).length;
});

const rol = authStore.getRol?.toLowerCase?.() || "empresa";

// Todas las opciones posibles
const allItems = [
  { label: "Inicio", icon: HomeIcon, path: "/dashboard/home", roles: ["empresa"] },
  { label: "Descargar App", icon: CloudArrowDownIcon, path: "/dashboard/download", roles: ["empresa"] },
  { label: "Soporte", icon: LifebuoyIcon, path: "/dashboard/support", roles: ["empresa"] },
  { label: "Planes y Facturación", icon: CreditCardIcon, path: "/dashboard/plans", roles: ["empresa"] },

  { label: "Soporte Clientes", icon: ChatBubbleLeftRightIcon, path: "/dashboard/chat", roles: ["asesor"] },
  { label: "Centro de ayuda", icon: QuestionMarkCircleIcon, path: "/dashboard/faq", roles: ["asesor"] },
  { label: "Clientes", icon: UserIcon, path: "/dashboard/clients", roles: ["superusuario"] },
  { label: "Auditoría", icon: ClipboardDocumentListIcon, path: "/dashboard/logs", roles: ["superusuario"] },
  { label: "Usuarios", icon: UsersIcon, path: "/dashboard/users", roles: ["superusuario"] },

  { label: "Configuración", icon: Cog6ToothIcon, path: "/dashboard/settings", roles: ["empresa"] },
  { label: "Configuración", icon: Cog6ToothIcon, path: "/dashboard/adminSettings", roles: ["asesor", "superusuario"] },
];

// Filtra según el rol
const sidebarItems = allItems.filter(item => item.roles.includes(rol));

const cerrarSesion = () => {
  authStore.logout();
};
</script>
