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
    // async fetchAccountStatus() {
    //   this.loading = true;
    //   try {
    //     const res = await homeService.getAccountStatus();
    //     this.accountStatus = res.data;
    //     this.error = null;
    //   } catch (e: any) {
    //     this.error = "No se pudo cargar el estado de la cuenta";
    //   } finally {
    //     this.loading = false;
    //   }
    // },
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