import { defineStore } from "pinia";
import authService from "@/services/authService";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: null as string | null,
    type: null as string | null,
    companyId: null as number | null,
    companyName: null as string | null,
    active: null as boolean | null,
    planName: null as string | null,
    planDuration: null as number | null,
    planStartDate: null as string | null,
    userId: null as number | null,
    fullname: null as string | null,
    email: null as string | null,
    rol: null as string | null,
    loading: false,
    error: null as string | null,
  }),
    getters: {
    getToken: (state) => {
      if (state.token) return state.token;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).token : null;
    },
    getType: (state) => {
      if (state.type) return state.type;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).type : null;
    },
    getCompanyId: (state) => {
      if (state.companyId) return state.companyId;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).companyId : null;
    },
    getCompanyName: (state) => {
      if (state.companyName) return state.companyName;
      const data = localStorage.getItem("authData");
      console.log(data);
      
      return data ? JSON.parse(data).companyName : null;
    },
    getActive: (state) => {
      if (state.active !== null) return state.active;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).active : null;
    },
    getPlanName: (state) => {
      if (state.planName) return state.planName;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).planName : null;
    },
    getPlanDuration: (state) => {
      if (state.planDuration) return state.planDuration;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).planDuration : null;
    },
    getPlanStartDate: (state) => {
      if (state.planStartDate) return state.planStartDate;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).planStartDate : null;
    },
    getUserId: (state) => {
      if (state.userId) return state.userId;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).userId : null;
    },
    getFullname: (state) => {
      if (state.fullname) return state.fullname;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).fullname : null;
    },
    getEmail: (state) => {
      if (state.email) return state.email;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).email : null;
    },
    getRol: (state) => {
      if (state.rol) return state.rol;
      const data = localStorage.getItem("authData");
      return data ? JSON.parse(data).rol : null;
    },
  },
  actions: {
    setAuthData(data: any) {
      this.token = data.token || null;
      this.type = data.type || null;
      this.companyId = data.companyId || null;
      this.companyName = data.companyName || null;
      this.active = data.active ?? null;
      this.planName = data.planName || null;
      this.planDuration = data.planDuration || null;
      this.planStartDate = data.planStartDate || null;
      this.userId = data.userId || null;
      this.fullname = data.fullname || null;
      this.email = data.email || null;
      this.rol = data.rol || null;
      localStorage.setItem("authData", JSON.stringify(this.$state));
    },
    loadAuthData() {
      const data = localStorage.getItem("authData");
      if (data) Object.assign(this, JSON.parse(data));
    },
    clearAuthData() {
      this.token = null;
      this.type = null;
      this.companyId = null;
      this.companyName = null;
      this.active = null;
      this.planName = null;
      this.planDuration = null;
      this.planStartDate = null;
      this.userId = null;
      this.fullname = null;
      this.email = null;
      this.rol = null;
      localStorage.removeItem("authData");
    },
    async registerCompany(payload: { companyName: string; fullname: string; companyEmail: string; password: string }) {
      try {
        this.error = null;
        const response = await authService.registerCompany(payload);
        this.loading = false;
        return response.data as ServerResponseModel;
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
        const serverResponse = response.data as ServerResponseModel;
        console.log(serverResponse.data);
        
        this.loading = false;
        if (!serverResponse.result) {
          this.error = serverResponse.data?.message || "Usuario o contraseña incorrectos";
          return serverResponse;
        }
        this.setAuthData(serverResponse.data);
        return serverResponse;
      } catch (error: any) {
        this.loading = false;
        this.error = "Usuario o contraseña incorrectos";
        throw error;
      }
    },
    logout() {
      this.clearAuthData();
    },
    clearError() {
      this.error = null;
    },
  },
});

