<template>
  <section class="flex flex-col justify-center items-center p-15 text-black">
    <div class="bg-white shadow-md rounded-lg py-7 px-10 max-w-130 w-full">
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Registrarse</h2>
      <p class="text-sm text-gray-500 mb-3">Ingrese sus datos para crear una cuenta en ArchivaCore</p>

      <form @submit.prevent="register">
        <!-- Correo Electrónico -->
        <FormField
          id="email"
          label="Correo Electrónico"
          v-model="fields.companyEmail"
          :error="errors.companyEmail"
          placeholder="ejemplo@correo.com"
        />

        <!-- Empresa -->
        <FormField
          id="company"
          label="Empresa"
          v-model="fields.companyName"
          :error="errors.companyName"
          placeholder="Ingrese el nombre de su empresa"
        />

        <!-- Empresa -->
        <FormField
          id="fullname"
          label="Nombre completo del representante"
          v-model="fields.fullname"
          :error="errors.fullname"
          placeholder="Ingrese el nombre completo del representante"
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

        <!-- Confirmar Contraseña -->
        <PasswordField
          id="confirmPassword"
          label="Confirmar Contraseña"
          v-model="fields.confirmPassword"
          :error="errors.confirmPassword"
          :show-password="showConfirmPassword"
          @toggle-password="toggleConfirmPassword"
        />

        <!-- Botón de Registro -->
        <button
          type="submit"
          class="w-full mt-2 bg-primary-500 text-white py-2 rounded-lg font-semibold shadow-sm hover:bg-primary-600 transition cursor-pointer"
          :disabled="authStore.loading"
        >
          <template v-if="authStore.loading">
            <svg class="animate-spin h-5 w-5 mr-2 inline-block text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
            </svg>
            Registrando...
          </template>
          <template v-else>
            Registrarse
          </template>
        </button>

        <div
          v-if="result && result.result"
          class="alert alert-success mt-4 shadow-lg"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24" color="white">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2l4-4" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10z" />
          </svg>
          <span class="text-white">{{ result.message }}</span>
        </div>

        <div
          v-else-if="result && result.message"
          class="alert alert-error mt-4 shadow-lg"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current flex-shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24" color="white">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-1.414-1.414A9 9 0 105.636 18.364l1.414 1.414A9 9 0 1018.364 5.636z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01" />
          </svg>
          <span class="text-white">{{ result.message }}</span>
        </div>
        <div
          v-else-if="authStore.error"
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
        ¿Ya tiene una cuenta?
        <router-link to="/login" class="text-primary-700 hover:underline">Iniciar sesión</router-link>
      </p>
    </div>
  </section>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useFormValidation } from "@/composables/useFormValidation";
import { useTogglePassword } from "@/composables/useTogglePassword";
import { useAuthStore } from "@/stores/authStore";
import { validEmail, onlyLettersAndSpaces, strongPassword, passwordsMatch, required } from "@/utils/validators";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";
import FormField from "@/components/inputs/FormField.vue";
import PasswordField from "@/components/inputs/PasswordField.vue";

const result = ref<ServerResponseModel | null>(null);

// Form validation setup
const { fields, errors, validateAll } = useFormValidation(
  {
    companyEmail: "",
    companyName: "",
    fullname: "",
    password: "",
    confirmPassword: "",
  },
  {
    companyEmail: [required, validEmail],
    companyName: [required, onlyLettersAndSpaces],
    fullname: [required, onlyLettersAndSpaces],
    password: [required, strongPassword],
    confirmPassword: [required, passwordsMatch],
  }
);

// Toggle password visibility using the composable
const { showPassword, togglePassword } = useTogglePassword();
const { showPassword: showConfirmPassword, togglePassword: toggleConfirmPassword } = useTogglePassword();

// Auth store
const authStore = useAuthStore();

// Limpiar el error al montar la vista
onMounted(() => {
  authStore.clearError();
});

// Register function
const register = async () => {
  if (!validateAll()) return;
  authStore.loading = true;
  const response = await authStore.registerCompany({
    companyName: fields.companyName,
    fullname: fields.fullname,
    companyEmail: fields.companyEmail,
    password: fields.password,
  });
  result.value = response;
  authStore.loading = false;
};
</script>