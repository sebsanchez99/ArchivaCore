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
    async registerCompany(payload: { companyName: string; fullname: string; companyEmail: string; password: string }) {
      try {
        this.error = null;
        const response = await authService.registerCompany(payload);
        const data = response.data as ServerResponseModel;
        if (!data.result) {
          this.error = data.message || "No se pudo registrar la empresa";
          return data;
        }
        return data;
      } catch (error: any) {
        this.loading = false;
        this.error = "No se pudo registrar la empresa";
        throw error;
  }
    },

    async loginCompany(payload: { companyEmail: string; password: string }) {
      try {
        this.error = null;
        const response = await authService.loginCompany(payload);
        const data = response.data as ServerResponseModel;
        if (!data.result) {
          this.error = data.data.message || "Usuario o contraseña incorrectos";
          return data;
        }
        this.token = data.data;
        localStorage.setItem("authToken", this.token!);
        return data;
      } catch (error: any) {
        this.loading = false;
        this.error = "Usuario o contraseña incorrectos";
        throw error;
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