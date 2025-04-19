<template>
    <section class="flex flex-col justify-center items-center pt-15 text-black">
      <div class="bg-white shadow-md rounded-lg py-7 px-10 max-w-md w-full">
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Iniciar Sesión</h2>
        <p class="text-sm text-gray-500 mb-6">Ingrese sus credenciales para acceder a su cuenta</p>
  
        <form @submit.prevent="login">
          <!-- Correo Electrónico -->
          <div class="mb-4">
            <label for="email" class="block text-sm font-semibold">Correo Electrónico</label>
            <div class="mt-1 flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pl-3 has-[input:focus-within]:border-secondary-500">
              <input
                id="email"
                v-model="email"
                type="email"
                placeholder="ejemplo@correo.com"
                class="w-full p-2 border-0 focus:ring-0 focus:outline-none text-gray-900"
                required
              />
            </div>
          </div>
  
          <!-- Contraseña -->
          <div class="mb-4">
            <label for="password" class="block text-sm font-semibold">Contraseña</label>
            <div class="mt-1 flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pl-3 has-[input:focus-within]:border-secondary-500">
              <input
                id="password"
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="••••••••"
                class="w-full p-2 border-0 focus:ring-0 focus:outline-none text-gray-900"
                required
              />
              <button type="button" @click="togglePassword" class="cursor-pointer p-2 text-primary-500 focus:outline-none">
                <EyeSlashIcon v-if="showPassword" class="w-5 h-5 text-secondary-500" />
                <EyeIcon v-else class="w-5 h-5 text-secondary-500" />
              </button>
            </div>
            <router-link to="/forgot-password" class="text-sm text-primary-700 hover:underline ml-2">
              ¿Olvidó su contraseña?
            </router-link>
          </div>
  
          <button
            @click="login"
            type="button"
            class="w-full bg-primary-500 text-white py-2 rounded-lg font-semibold shadow-sm hover:bg-primary-600 transition cursor-pointer">
            Iniciar Sesión
          </button>
        </form>
  
        <p class="text-center text-sm text-gray-600 mt-4">
          ¿No tiene una cuenta? 
          <router-link to="/register" class="text-primary-700 hover:underline">Registrarse</router-link>
        </p>
      </div>
    </section>
</template>
  
<script setup>
import { ref } from "vue";
import { EyeIcon, EyeSlashIcon } from "@heroicons/vue/24/outline";
import { useRouter } from "vue-router";
  
  const email = ref("");
  const password = ref("");
  const showPassword = ref(false);

  const router = useRouter()
  
  const togglePassword = () => {
    showPassword.value = !showPassword.value;
  };
  
  const login = () => {
    console.log("Correo:", email.value, "Contraseña:", password.value);
    router.replace({
      name: 'dashboard'
    })
  };
</script>
  