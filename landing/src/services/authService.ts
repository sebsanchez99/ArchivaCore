import httpClient from "@/services/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  registerCompany(payload: { companyName: string; companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel<null>>("/auth/register", payload);
  },
  loginCompany(payload: { companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel<{ token: string }>>("/auth/login", payload); // Nueva ruta
  },
};