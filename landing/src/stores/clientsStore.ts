import { defineStore } from "pinia";
import clientService from "@/services/clientsService";
import type { Client } from "@/interfaces/client";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";
import type { Log } from "@/interfaces/log";

export const useClientsStore = defineStore('clients', {
    state: () => ({
        loading: false,
        error: null as string | null,
        response: null as ServerResponseModel | null,
        clients:[]  as Client[],
        logs: [] as Log[],
        companyLogs: [] as Log[]
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

        async fecthLogs() {
            try {
                const response = await clientService.getLogs()
                this.logs = response.data.data.map((l : any) => ({
                    id: l._log_id,
                    table: l._tabla,
                    register: l._registro,
                    type: l._tipo,
                    description: l._descripcion,
                    date: new Date(l._fecha),
                    user: l._usuario || null,
                    username: l._usuario_nombre || null,
                    oldData: l._datos_anteriores || null,
                    newData: l._datos_nuevos || null
                }))
            } catch (error) {
                this.error = 'No se pudieron cargar los logs'
            }
        },

        async fetchCompanyLogs(companyId: string | null) {
            try {
                const response = await clientService.getCompanyLogs({ companyId })
                this.companyLogs = response.data.data.map((l : any) => ({
                    id: l._log_id,
                    table: l._tabla,
                    register: l._registro,
                    type: l._tipo,
                    description: l._descripcion,
                    date: new Date(l._fecha),
                    user: l._usuario || null,
                    username: l._usuario_nombre || null,
                    oldData: l._datos_anteriores || null,
                    newData: l._datos_nuevos || null
                }))
            } catch (error) {
                this.error = 'No se pudieron cargar los logs de la empresa'
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