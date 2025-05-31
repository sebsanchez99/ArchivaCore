import httpClient from "@/services/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  registerCompany(payload: { companyName: string; companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel<null>>("/api/v1/web/auth/register", payload);
  },
  loginCompany(payload: { companyEmail: string; password: string }) {
    return httpClient.post<ServerResponseModel<{ token: string }>>("/api/v1/web/auth/login", payload); // Nueva ruta
  },
};