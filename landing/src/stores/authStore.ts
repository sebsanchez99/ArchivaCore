import { defineStore } from "pinia";
import authService from "@/services/authService";
import type { RegisterPayload, LoginPayload } from "@/interfaces/authInterfaces";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null as Record<string, any> | null,
    token: null as string | null,
    loading: false,
    error: null as string | null,
  }),
  actions: {
    async registerUser(payload: RegisterPayload) {
      this.loading = true;
      this.error = null;
      try {
        const response = await authService.registerUser(payload);
        const data = response.data as ServerResponseModel<{ user: any; token: string }>;

        if (data.result) {
          this.user = data.data.user;
          this.token = data.data.token;

          // Guardar el token en localStorage si no es null
          if (this.token) {
            localStorage.setItem("authToken", this.token);
          }
        } else {
          this.error = data.message;
        }

        return data;
      } catch (error: any) {
        this.error = error.response?.data?.message || "Error al registrar el usuario";
        throw error;
      } finally {
        this.loading = false;
      }
    },
    async loginUser(payload: LoginPayload) {
      this.loading = true;
      this.error = null;
      try {
        const response = await authService.loginUser(payload);
        const data = response.data as ServerResponseModel<{ user: any; token: string }>;

        if (data.result) {
          this.user = data.data.user;
          this.token = data.data.token;

          // Guardar el token en localStorage si no es null
          if (this.token) {
            localStorage.setItem("authToken", this.token);
          }
        } else {
          this.error = data.message;
        }

        return data;
      } catch (error: any) {
        this.error = error.response?.data?.message || "Error al iniciar sesión";
        throw error;
      } finally {
        this.loading = false;
      }
    },
    logout() {
      this.user = null;
      this.token = null;

      // Eliminar el token de localStorage
      localStorage.removeItem("authToken");
    },
  },
});