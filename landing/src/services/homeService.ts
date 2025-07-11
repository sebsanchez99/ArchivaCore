import httpClient from "@/config/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  getAccountStatus() {
    return httpClient.get<ServerResponseModel>("/api/company/account-status");
  },
  getStorage() {
    return httpClient.get<ServerResponseModel>("/supabase/getTotalStorage");
  }
};