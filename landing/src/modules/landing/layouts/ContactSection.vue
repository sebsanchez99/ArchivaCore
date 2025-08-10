<template>
  <footer class="bg-secondary-100 text-gray-800 py-10 pt-4 px-10">
    <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-10">
      <!-- Logo + Empresa -->
      <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-4">
        <img src="@/assets/logoDevCore.png" class="w-28 h-auto" alt="Logo DevCore">
        <p class="text-sm leading-relaxed max-w-sm">
          Somos especialistas en la automatización de procesos empresariales. Desarrollamos soluciones que mejoran la eficiencia, reducen costos y optimizan el rendimiento de su empresa.
        </p>
      </div>

      <!-- Enlaces -->
      <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-2">
        <h4 class="text-lg font-semibold text-gray-900">Enlaces</h4>
        <a href="#" @click.prevent="scrollTo('home')" class="hover:text-primary-500">Inicio</a>
        <a href="#" @click.prevent="scrollTo('features')" class="hover:text-primary-500">Características</a>
        <a href="#" @click.prevent="scrollTo('pricing')" class="hover:text-primary-500">Planes</a>
      </div>

      <!-- Contacto -->
      <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-2">
        <h4 class="text-lg font-semibold text-gray-900">Contacto</h4>
        <a href="mailto:devcoresas@gmail.com" class="hover:text-primary-500">devcoresas@gmail.com</a>
        <a href="tel:+57345464645645" class="hover:text-primary-500">+57 345 464 645645</a>
        <p>Bogotá D.C</p>
      </div>
    </div>

    <!-- Línea divisoria -->
    <div class="mt-10 border-t border-primary-600 pt-4 text-center text-primary-600 text-sm">
      © {{ new Date().getFullYear() }} DevCore. Todos los derechos reservados.
    </div>
  </footer>
</template>

<script setup>
const scrollTo = (id) => {
  const section = document.getElementById(id);
  if (section) {
    section.scrollIntoView({ behavior: "smooth" });
  }
};
</script>
