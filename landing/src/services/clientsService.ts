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

    getCompanyLogs(payload: { companyyId: string }) {
        return httpClient.get<ServerResponseModel>('/admin/getCompanyLogs', { params: payload })
    },

    getLogs() {
        return httpClient.get<ServerResponseModel>('/admin/getLogs')
    },

    deleteLogs(payload: { date: string }) {
        return httpClient.delete<ServerResponseModel>('/admin/deleteLogs', { data: payload })
    }
}