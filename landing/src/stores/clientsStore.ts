import { defineStore } from "pinia";
import clientService from "@/services/clientsService";
import type { Client } from "@/interfaces/client";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export const useClientsStore = defineStore('clients', {
    state: () => ({
        loading: false,
        error: null as string | null,
        response: null as ServerResponseModel | null,
        clients:[]  as Client[]
    }),
    actions: {
        async fetchClients() {
            try {
                const response = await clientService.getClients()
                this.clients = response.data.data.map((c : any) => ({
                    id: c._emp_id,
                    name: c._emp_nombre,
                    fullname: c._emp_nombrecompleto,
                    email: c._emp_correo,
                    registerDate: new Date(c._emp_fecharegistro),
                    active: c._emp_activo,
                    initialDate: new Date(c._emp_fechainicio),
                    planName: c._plan_nombre,
                }))
            } catch (error) {
                this.error = 'No se pudieron cargar los clientes';
            }
        },
        
        async changePassword(companyId: string, newPassword: string) {
            try {
                const response = await clientService.changeCompanyPassword({ companyId, newPassword })
                this.response = response.data;
            } catch (error) {
                this.error = 'Error interno del servidor'
            }
        },

        async changeUserStatus(companyId: string, newState: boolean) {
            try {
                const response = await clientService.updateState({ companyId, newState })
                this.response = response.data
            } catch (error) {
                this.error = 'Error interno del servidor'
            }
        },

        async deleteCompany(companyId: string) {
            try {
                const response = await clientService.deleteClient({ companyId })
                this.response = response.data
            } catch (error) {
                this.error = 'Error interno del servidor'
            }
        },
        
        resetMessages() {
            this.response = null;
            this.error = null;
        }
    }
})