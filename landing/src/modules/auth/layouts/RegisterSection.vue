<template>
    <section class="flex flex-col justify-center items-center p-15 text-black">
      <div class="bg-white shadow-md rounded-lg py-7 px-10 max-w-130 w-full">
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Registrarse</h2>
        <p class="text-sm text-gray-500 mb-6">Ingrese sus datos para crear una cuenta en ArchivaCore</p>
  
        <form @submit.prevent="register">
  
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
  
          <!-- Empresa -->
          <div class="mb-4">
            <label for="company" class="block text-sm font-semibold">Empresa</label>
            <div class="mt-1 flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pl-3 has-[input:focus-within]:border-secondary-500">
              <input
                id="company"
                v-model="company"
                type="text"
                placeholder="Ingrese el nombre de su empresa"
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
              <button type="button" @click="togglePassword" class="cursor-pointer p-2 text-secondary-500 focus:outline-none">
                <EyeSlashIcon v-if="showPassword" class="w-5 h-5" />
                <EyeIcon v-else class="w-5 h-5" />
              </button>
            </div>
          </div>
  
          <!-- Confirmar Contraseña -->
          <div class="mb-4">
            <label for="confirmPassword" class="block text-sm font-semibold">Confirmar Contraseña</label>
            <div class="mt-1 flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pl-3 has-[input:focus-within]:border-secondary-500">
              <input
                id="confirmPassword"
                v-model="confirmPassword"
                :type="showConfirmPassword ? 'text' : 'password'"
                placeholder="••••••••"
                class="w-full p-2 border-0 focus:ring-0 focus:outline-none text-gray-900"
                required
              />
              <button type="button" @click="toggleConfirmPassword" class="cursor-pointer p-2 text-secondary-500 focus:outline-none">
                <EyeSlashIcon v-if="showConfirmPassword" class="w-5 h-5" />
                <EyeIcon v-else class="w-5 h-5" />
              </button>
            </div>
          </div>
  
          <!-- Plan -->
          <div class="mb-4">
            <label for="plan" class="block text-sm font-semibold">Plan</label>
            <div class="mt-1 flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pr-3 has-[select:focus-within]:border-secondary-500">
              <select
                id="plan"
                v-model="plan"
                class="w-full p-2 focus:outline-none text-gray-900 bg-transparent"
                required
              >
                <option value="demo">DEMO (14 días gratis)</option>
                <option value="premium">Premium</option>
              </select>
            </div>
          </div>
  
          <!-- Botón de Registro -->
          <button
            type="submit"
            class="w-full bg-primary-500 text-white py-2 rounded-lg font-semibold shadow-sm hover:bg-primary-600 transition cursor-pointer">
            Registrarse
          </button>
        </form>
  
        <p class="text-center text-sm text-gray-600 mt-4">
          ¿Ya tiene una cuenta?
          <router-link to="/login" class="text-primary-700 hover:underline">Iniciar Sesión</router-link>
        </p>
      </div>
    </section>
  </template>
  
  <script setup>
  import { ref } from "vue";
  import { EyeIcon, EyeSlashIcon } from "@heroicons/vue/24/outline";
  
  const firstName = ref("");
  const lastName = ref("");
  const email = ref("");
  const company = ref("");
  const password = ref("");
  const confirmPassword = ref("");
  const plan = ref("demo");
  
  const showPassword = ref(false);
  const showConfirmPassword = ref(false);
  
  const togglePassword = () => {
    showPassword.value = !showPassword.value;
  };
  
  const toggleConfirmPassword = () => {
    showConfirmPassword.value = !showConfirmPassword.value;
  };
  
  const register = () => {
    console.log("Registrando usuario:", {
      firstName: firstName.value,
      lastName: lastName.value,
      email: email.value,
      company: company.value,
      password: password.value,
      confirmPassword: confirmPassword.value,
      plan: plan.value,
    });
  };
  </script>
  