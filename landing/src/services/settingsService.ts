import httpClient from "@/config/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
    changeCompanyPassword(payload: { newPassword: string }) {
        return httpClient.put<ServerResponseModel>('/settings/changeCompanyPassword', payload);
    },

    changeUserPassword(payload: { newPassword: string }) {
        return httpClient.put<ServerResponseModel>('/settings/changeUserPassword', payload)
    },

    updateUserInfo(payload: { username: string | null; fullname: string | null }) {
        return httpClient.put<ServerResponseModel>('/settings/updateUserInfo', payload)
    },

    deleteCompany() {
        return httpClient.delete<ServerResponseModel>('/settings/deleteCompanyAccount')
    },
}