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

        <!-- Mensaje de error -->
        <p v-if="authStore.error" class="text-red-500 text-sm mt-2 text-center">
          {{ authStore.error }}
        </p>
      </form>

      <p class="text-center text-sm text-gray-600 mt-4">
        ¿Ya tiene una cuenta?
        <router-link to="/login" class="text-primary-700 hover:underline">Iniciar sesión</router-link>
      </p>
    </div>
  </section>
</template>

<script setup>
import { useFormValidation } from "@/composables/useFormValidation";
import { useTogglePassword } from "@/composables/useTogglePassword";
import { useAuthStore } from "@/stores/authStore";
import FormField from "@/components/inputs/FormField.vue";
import PasswordField from "@/components/inputs/PasswordField.vue";
import { onMounted } from "vue";
import { useRouter } from "vue-router";

// Form validation setup
const { fields, errors, validateAll } = useFormValidation(
  {
    companyEmail: "",
    companyName: "",
    password: "",
    confirmPassword: "",
  },
  {
    companyEmail: (value) => (!value.includes("@") ? "El correo electrónico debe ser válido" : null),
    companyName: (value) => (value.length < 3 ? "El nombre de la empresa debe tener al menos 3 caracteres" : null),
    password: (value) => (value.length < 5 ? "La contraseña debe tener al menos 5 caracteres" : null),
    confirmPassword: (value, fields) =>
      value !== fields.password ? "Las contraseñas no coinciden" : null,
  }
);

// Toggle password visibility using the composable
const { showPassword, togglePassword } = useTogglePassword();
const { showPassword: showConfirmPassword, togglePassword: toggleConfirmPassword } = useTogglePassword();

// Auth store
const authStore = useAuthStore();
const router = useRouter();

// Limpiar el error al montar la vista
onMounted(() => {
  authStore.clearError();
});

// Register function
const register = async () => {
  if (!validateAll()) {
    return;
  }

  try {
    console.log("Registrando empresa:", fields.companyName, fields.companyEmail, fields.password);
    
    const response = await authStore.registerCompany({
      companyName: fields.companyName,
      companyEmail: fields.companyEmail,
      password: fields.password,
    });

    if (response.result) {
      router.push("/login");
    }
  } catch (error) {
    console.error("Error al registrar la empresa:", error);
  }
};
</script>