<template>
    <footer class="bg-primary-200 text-gray-800 py-10 pt-4" style="--color-primary-200: #d9e5ec; background-color: var(--color-primary-200);">
      <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-10">
        <!-- Logo + Empresa -->
        <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-4">
          <!-- Logo circular -->
          <img src="@/assets/logoDevCore.png" class="w-28 h-auto">
          <p class="text-sm text-gray-700 leading-relaxed max-w-sm">
            Somos especialistas en la automatización de procesos empresariales. Desarrollamos soluciones que mejoran la eficiencia, reducen costos y optimizan el rendimiento de su empresa.
          </p>
        </div>
  
        <!-- Enlaces -->
        <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-2">
          <h4 class="text-lg font-bold text-gray-900 mb-2">Enlaces</h4>
          <a href="#" class="hover:underline text-gray-700">Inicio</a>
          <a href="#" class="hover:underline text-gray-700">Servicios</a>
          <a href="#" class="hover:underline text-gray-700">Proyectos</a>
          <a href="#" class="hover:underline text-gray-700">Contacto</a>
        </div>
  
        <!-- Contacto -->
        <div class="flex flex-col items-center md:items-start text-center md:text-left space-y-2">
          <h4 class="text-lg font-bold text-gray-900 mb-2">Contacto</h4>
          <p class="text-gray-700">info@devcore.com</p>
          <p class="text-gray-700">+57 345 464 645645</p>
          <p class="text-gray-700">Bogotá</p>
        </div>
      </div>
  
      <!-- Línea divisoria -->
      <div class="mt-10 border-t border-gray-400 pt-4 text-center text-gray-600 text-sm">
        © {{ new Date().getFullYear() }} DevCore. Todos los derechos reservados.
      </div>
    </footer>
  </template>
  