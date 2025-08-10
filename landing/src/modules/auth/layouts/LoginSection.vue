<template>
  <section class="flex flex-col justify-center items-center pt-15 text-black">
    <div class="bg-white shadow-md rounded-lg py-7 px-10 max-w-md w-full">
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Iniciar Sesión</h2>
      <p class="text-sm text-gray-500 mb-3">Ingrese sus credenciales para acceder a su cuenta</p>

      <form @submit.prevent="login">
        <!-- Correo Electrónico -->
        <FormField
          id="email"
          label="Correo Electrónico"
          v-model="fields.companyEmail"
          :error="errors.companyEmail"
          placeholder="ejemplo@correo.com"
        />

        <!-- Contraseña -->
        <PasswordField
          id="password"
          label="Contraseña"
          v-model="fields.password"
          :error="errors.password"
          :show-password="showPassword"
          @toggle-password="togglePassword"
        />

        <!-- Botón de Inicio de Sesión -->
        <button 
          type="submit"
          class="w-full bg-primary-500 text-white py-2 mt-2 rounded-lg font-semibold shadow-sm hover:bg-primary-600 transition cursor-pointer"
          :disabled="authStore.loading"
        >
          <template v-if="authStore.loading">
            <svg class="animate-spin h-5 w-5 mr-2 inline-block text-white" xmlns="http://www.w3.org/2000/svg"
              fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
            </svg>
            Iniciando...
          </template>
          <template v-else>
            Iniciar Sesión
          </template>
        </button>

        <!-- Mensaje de error -->
        <div
          v-if="authStore.error"
          class="alert alert-error mt-4 shadow-lg"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24" color="white">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-1.414-1.414A9 9 0 105.636 18.364l1.414 1.414A9 9 0 1018.364 5.636z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01" />
          </svg>
          <span class="text-white">{{ authStore.error }}</span>
        </div>  
      </form>

      <p class="text-center text-sm text-gray-600 mt-4">
        ¿No tiene una cuenta?
        <router-link to="/register" class="text-primary-700 hover:underline">Registrarse</router-link>
      </p>
    </div>
  </section>
</template>

<script setup>
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useFormValidation } from "@/composables/useFormValidation";
import { useTogglePassword } from "@/composables/useTogglePassword";
import { useAuthStore } from "@/stores/authStore";
import { required } from "@/utils/validators";
import FormField from "@/components/inputs/FormField.vue";
import PasswordField from "@/components/inputs/PasswordField.vue";

// Form validation setup
const { fields, errors, validateAll } = useFormValidation(
  {
    companyEmail: "",
    password: "",
  },
  {
    companyEmail: [required],
    password: [required],
  }
);

// Toggle password visibility using the composable
const { showPassword, togglePassword } = useTogglePassword();

// Auth store
const authStore = useAuthStore();

const router = useRouter();

// Limpiar el error al montar la vista
onMounted(() => {
  authStore.clearError();
});

// Función de inicio de sesión
const login = async () => {
  if (!validateAll()) return
  authStore.loading = true;
  const response = await authStore.loginCompany({
    companyEmail: fields.companyEmail,
    password: fields.password,
  });
  authStore.loading = false;
  if (response.result) {
    const role = authStore.getRol;
    const homeRoutesByRole = {
      Empresa: 'dashboard',
      Superusuario: 'dashboard/clients',
      Asesor: 'dashboard/chat',
    }
    const target = homeRoutesByRole[role] || 'dashboard/home';
    router.replace(target)
  };
};
</script>