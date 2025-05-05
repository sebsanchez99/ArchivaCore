import httpClient from "@/services/httpClient";
import type { RegisterPayload, LoginPayload } from "@/interfaces/authInterfaces";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  registerUser(payload: RegisterPayload) {
    return httpClient.post<ServerResponseModel<{ user: any; token: string }>>("/auth/register", payload);
  },
  loginUser(payload: LoginPayload) {
    return httpClient.post<ServerResponseModel<{ user: any; token: string }>>("/auth/login", payload);
  },
  getUserProfile() {
    return httpClient.get<ServerResponseModel<{ user: any }>>("/auth/profile");
  },
};