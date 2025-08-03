import httpClient from "@/config/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
    getClients() {
        return httpClient.get<ServerResponseModel>('/admin/getClients');
    },

    changeCompanyPassword(payload: { companyId: string; newPassword: string }) {
        return httpClient.put<ServerResponseModel>('/admin/changeCompanyPassword', payload)
    },

    deleteClient(payload: { companyId: string }) {
        return httpClient.delete<ServerResponseModel>('/admin/deleteClient', { data: payload })
    },

    updateState(payload: { companyId: string; newState: boolean }) {
        return httpClient.put<ServerResponseModel>('/admin/updateState', payload)
    },

    getCompanyLogs(payload: { companyId: string | null}) {
        return httpClient.get<ServerResponseModel>('/admin/getCompanyLogs', { params: payload })
    },

    getLogs() {
        return httpClient.get<ServerResponseModel>('/admin/getLogs')
    },

    deleteLogs(payload: { date: string }) {
        return httpClient.delete<ServerResponseModel>('/admin/deleteLogs', { data: payload })
    },

    getAdminUsers() {
        return httpClient.get<ServerResponseModel>('/admin/getAdminUsers')
    },

    createSuperuser(payload: { username: string, fullname: string, password: string }) {
        return httpClient.post<ServerResponseModel>('/admin/createSuperuser', payload)
    },

    createSupportUser(payload: { username: string, fullname: string, password: string }) {
        return httpClient.post<ServerResponseModel>('/admin/createSupportUser', payload)
    },

    updateAdminUser(payload: { username: string | null, fullname: string | null, password: string | null }) {
        return httpClient.put<ServerResponseModel>('/admin/updateAdminUser', payload)
    },

    changeStateAdminUser(payload: { userId: string, newState:boolean }) {
        return httpClient.put<ServerResponseModel>('/admin/changeStateAdminUser', payload)
    },

    deleteAdminUser(payload: { userId: string }) {
        return httpClient.delete<ServerResponseModel>('/admin/deleteAdminUser', { data: payload })
    },

}