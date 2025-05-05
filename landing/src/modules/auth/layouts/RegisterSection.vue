<template>
  <section class="flex flex-col justify-center items-center p-15 text-black">
    <div class="bg-white shadow-md rounded-lg py-7 px-10 max-w-130 w-full">
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Registrarse</h2>
      <p class="text-sm text-gray-500 mb-3">Ingrese sus datos para crear una cuenta en ArchivaCore</p>

      <form @submit.prevent="register">
        <!-- Correo Electrónico -->
        <FormField id="email" label="Correo Electrónico" v-model="fields.email" :error="errors.email"
          placeholder="ejemplo@correo.com" />

        <!-- Empresa -->
        <FormField id="company" label="Empresa" v-model="fields.company" :error="errors.company"
          placeholder="Ingrese el nombre de su empresa" />

        <!-- Contraseña -->
        <PasswordField id="password" label="Contraseña" v-model="fields.password" :error="errors.password"
          :show-password="showPassword" @toggle-password="togglePassword" />

        <!-- Confirmar Contraseña -->
        <PasswordField id="confirmPassword" label="Confirmar Contraseña" v-model="fields.confirmPassword"
          :error="errors.confirmPassword" :show-password="showConfirmPassword"
          @toggle-password="toggleConfirmPassword" />

        <!-- Botón de Registro -->
        <button type="submit"
          class="w-full mt-2 bg-primary-500 text-white py-2 rounded-lg font-semibold shadow-sm hover:bg-primary-600 transition cursor-pointer">
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
import { useFormValidation } from "@/composables/useFormValidation";
import { useTogglePassword } from "@/composables/useTogglePassword";
import FormField from "@/components/inputs/FormField.vue";
import PasswordField from "@/components/inputs/PasswordField.vue";

// Form validation setup
const { fields, errors, validateAll } = useFormValidation(
  {
    email: "",
    company: "",
    password: "",
    confirmPassword: "",
  },
  {
    email: (value) => (!value.includes("@") ? "El correo electrónico debe ser válido" : null),
    company: (value) => (value.length < 3 ? "El nombre de la empresa debe tener al menos 3 caracteres" : null),
    password: (value) => {
      const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
      return !passwordRegex.test(value)
        ? "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, un número y un carácter especial"
        : null;
    },
    confirmPassword: (value, fields) =>
      value !== fields.password ? "Las contraseñas no coinciden" : null,
  }
);

// Toggle password visibility using the composable
const { showPassword, togglePassword } = useTogglePassword();
const { showPassword: showConfirmPassword, togglePassword: toggleConfirmPassword } = useTogglePassword();

// Register function
const register = () => {
  if (!validateAll()) {
    console.log("Errores en el formulario:", errors.value);
    return;
  }

  console.log("Registrando usuario:", fields.value);
};
</script>