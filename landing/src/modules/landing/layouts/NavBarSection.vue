<template>
  <div class="navbar bg-white base-100 fixed top-0 z-50 w-full backdrop-blur-sm">
    <div class="navbar-start">
      <div class="flex items-center gap-2 font-semibold">
        <img alt="Logo de ArchivaCore" src="@/assets/logoPrincipal.png" class="w-8 h-8 sm:w-10 sm:h-10" />
        <span class="text-lg font-bold text-text-500">ArchivaCore</span>
      </div>
    </div>

    <div class="navbar-center hidden md:flex">
      <ul class="menu menu-horizontal px-1 text-black">
        <li><button @click="$emit('scrollTo', 'home')" class="hover:text-primary-500 font-semibold">Inicio</button></li>
        <li><button @click="$emit('scrollTo', 'features')" class="hover:text-primary-500 font-semibold">Características</button></li>
        <li><button @click="$emit('scrollTo', 'pricing')" class="hover:text-primary-500 font-semibold">Planes</button></li>
        <li><button @click="$emit('scrollTo', 'contact')" class="hover:text-primary-500 font-semibold">Contacto</button></li>
      </ul>
    </div>

    <div class="navbar-end">
      <!-- Botones escritorio -->
      <div class="hidden md:flex gap-2">
        <NavButton to="/login" label="Iniciar sesión">Iniciar Sesión</NavButton>
        <NavButton to="/register" primary label="Registrarse">Registrarse</NavButton>
      </div>

      <!-- Dropdown móvil -->
      <div class="dropdown dropdown-end md:hidden">
        <label tabindex="0" class="btn btn-ghost hover:bg-primary-100 border-none rounded-xl">
          <Bars3Icon class="text-primary-500 w-8 "/>
        </label>
        <ul tabindex="0" class="menu menu-md dropdown-content p-5 shadow bg-primary-200 rounded-box text-text-500 w-50">
          <li><button @click="scrollAndClose('home')" class="hover:bg-primary-500 font-semibold">Inicio</button></li>
          <li><button @click="scrollAndClose('features')" class="hover:bg-primary-500 font-semibold">Características</button></li>
          <li><button @click="scrollAndClose('pricing')" class="hover:bg-primary-500 font-semibold">Planes</button></li>
          <li><button @click="scrollAndClose('contact')" class="hover:bg-primary-500 font-semibold">Contacto</button></li>
          <div>
            <li class="py-2"><NavButton to="/login" label="Iniciar sesión">Iniciar Sesión</NavButton></li>
            <li><NavButton to="/register" primary label="Registrarse">Registrarse</NavButton></li>
          </div>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import NavButton from '@/components/buttons/NavButton.vue';
import { Bars3Icon } from "@heroicons/vue/24/outline";

const emit = defineEmits(["scrollTo"]);

const scrollAndClose = (sectionId) => {
  document.getElementById(sectionId)?.scrollIntoView({ behavior: "smooth" });
};
</script>
