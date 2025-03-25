<template>
  <header class="w-full border-b border-primary-300">
    <div class="flex items-center justify-between h-14 px-4 sm:h-16 md:px-6 lg:px-8 max-w-7xl mx-auto w-full">
      <!-- Logo a la izquierda -->
      <div class="flex items-center gap-2 font-semibold">
        <img alt="Logo de ArchivaCore" src="@/assets/logo.png" class="w-8 h-8 sm:w-10 sm:h-10" />
        <span class="text-lg font-bold">ArchivaCore</span>
      </div>

      <!-- Menú hamburguesa (móvil) -->
      <button
        @click="isMobileMenuOpen = !isMobileMenuOpen"
        class="md:hidden focus:outline-none"
        aria-label="Abrir menú"
        :aria-expanded="isMobileMenuOpen"
      >
        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2"
          viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
          <path v-if="!isMobileMenuOpen" d="M4 6h16M4 12h16M4 18h16" />
          <path v-else d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>

      <!-- Menú y botones (desktop) -->
      <div class="hidden md:flex flex-1 items-center justify-between">
        <!-- Opciones de navegación -->
        <nav class="flex items-center space-x-4 sm:space-x-6 mx-auto h-10">
          <RouterLink to="/" class="text-sm font-medium hover:text-primary-700">Inicio</RouterLink>
          <RouterLink to="/features" class="text-sm font-medium hover:text-primary-700">Características</RouterLink>
          <RouterLink to="/pricing" class="text-sm font-medium hover:text-primary-700">Planes</RouterLink>
          <RouterLink to="/contact" class="text-sm font-medium hover:text-primary-700">Contacto</RouterLink>
        </nav>

        <!-- Botones -->
        <div class="flex items-center gap-2">
          <NavButton label="Iniciar sesión">Iniciar Sesión</NavButton>
          <NavButton primary label="Registrarse">Registrarse</NavButton>
        </div>
      </div>
    </div>

    <!-- Menú desplegable (móvil) -->
    <transition name="fade">
      <div v-if="isMobileMenuOpen" class="sm:hidden px-4 pt-2 pb-4 space-y-2 bg-white border-t border-primary-200">
        <nav class="flex flex-col items-center space-y-2">
          <RouterLink to="/" class="text-sm font-medium hover:text-primary-700">Inicio</RouterLink>
          <RouterLink to="/features" class="text-sm font-medium hover:text-primary-700">Características</RouterLink>
          <RouterLink to="/pricing" class="text-sm font-medium hover:text-primary-700">Planes</RouterLink>
          <RouterLink to="/contact" class="text-sm font-medium hover:text-primary-700">Contacto</RouterLink>
        </nav>

        <div class="pt-2 flex flex-col gap-2">
          <NavButton label="Iniciar sesión">Iniciar Sesión</NavButton>
          <NavButton primary label="Registrarse">Registrarse</NavButton>
        </div>
      </div>
    </transition>
  </header>
</template>

<script setup>
import { ref } from 'vue';
import NavButton from '@/components/buttons/NavButton.vue';

const isMobileMenuOpen = ref(false);
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: all 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
