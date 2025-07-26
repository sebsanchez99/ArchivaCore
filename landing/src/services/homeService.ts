import httpClient from "@/config/httpClient";
import type { ServerResponseModel } from "@/interfaces/serverResponseModel";

export default {
  getStorage() {
    return httpClient.get<ServerResponseModel>("/supabase/getTotalStorage");
  }
};