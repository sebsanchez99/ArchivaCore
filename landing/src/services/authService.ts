import httpClient from "@/config/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  registerCompany(payload: { companyName: string; fullname: string; companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel>("/auth/register", payload);
  },
  loginCompany(payload: { companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel>("/auth/login", payload); // Nueva ruta
  },
};