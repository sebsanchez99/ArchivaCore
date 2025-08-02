import { defineStore } from "pinia";
import homeService from "@/services/homeService";

export const useHomeStore = defineStore("home", {
  state: () => ({
    accountStatus: null as any,
    storage: null as any,
    loading: false,
    error: null as string | null,
  }),
  actions: {
    async fetchStorage() {
      try {
        const response = await homeService.getStorage();
        this.storage = response.data.data;
      } catch (e: any) {
        this.error = "No se pudo cargar el almacenamiento";
      } 
    },
  },
});