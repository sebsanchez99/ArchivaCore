import { defineStore } from "pinia";
import authService from "@/services/authService";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    user: null as Record<string, any> | null,
    token: null as string | null,
    loading: false,
    error: null as string | null,
  }),
  actions: {
    async registerCompany(payload: { companyName: string; companyEmail: string; password: string }) {
      this.loading = true;
      this.error = null;
      try {
        const response = await authService.registerCompany(payload);

        const data = response.data as ServerResponseModel<null>;

        if (!data.result) {
          this.error = "No se pudo registrar la empresa";
        }

        return data;
      } catch (error: any) {
        this.error = "No se pudo registrar la empresa";
        throw error;
      } finally {
        this.loading = false;
      }
    },
    async loginCompany(payload: { companyEmail: string; password: string }) {
      this.loading = true;
      this.error = null;
      try {
        const response = await authService.loginCompany(payload);
        const data = response.data as ServerResponseModel<{ token: string }>;

        if (data.result) {
          this.token = data.data.token;

          // Guardar el token en localStorage
          if (this.token) {
            localStorage.setItem("authToken", this.token);
          }
        } else {
          this.error = "Usuario o contraseña incorrectos";
        }

        return data;
      } catch (error: any) {
        this.error = error.response?.data?.message || "Usuario o contraseña incorrectos";
        throw error;
      } finally {
        this.loading = false;
      }
    },
    logout() {
      this.user = null;
      this.token = null;
      localStorage.removeItem("authToken");
    },
    clearError() {
      this.error = null;
    },
  },
});