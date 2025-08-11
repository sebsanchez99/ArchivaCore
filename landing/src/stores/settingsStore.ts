import { defineStore } from "pinia"
import settingsService from "@/services/settingsService"
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export const useSettingsStore = defineStore('settings',{
    state: () => ({
        loading: false,
        error: null as string | null,
        response: null as ServerResponseModel | null,
    }),
    actions: {
        async changeCompanyPassword(newPassword: string) {
            try {
                const response = await settingsService.changeCompanyPassword({ newPassword })
                this.response = response.data
            } catch (error) {
                this.error = 'No se pudo realizar el cambio de contraseña. Intente más tarde.'
            }
        },
        
        async changeUserPassword(newPassword : string) {
            try {
                const response = await settingsService.changeUserPassword({ newPassword })
                this.response = response.data
            } catch (error) {
                this.error = 'No se pudo realizar el cambio de contraseña. Intente más tarde.'
            }
        },

        async updateUserInfo(username: string | null, fullname: string | null) {
            try {
                const response = await settingsService.updateUserInfo({ username, fullname })
                console.log(response);
                
                this.response = response.data
            } catch (error) {
                this.error = 'No se pudo actualizar la información. Intente más tarde.'
            }
        },

        async deleteCompany() {
            try {
                const response = await settingsService.deleteCompany()
                this.response = response.data
            } catch (error) {
                this.error = 'No se pudo actualizar la información. Intente más tarde.'
            }
        },

        resetMessages() {
            this.response = null;
            this.error = null;
        }
    }
})
