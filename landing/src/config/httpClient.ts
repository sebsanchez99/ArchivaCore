import axios from "axios";

const httpClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptores de solicitud
httpClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("authToken");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptores de respuesta
httpClient.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error("Error en la API:", error.response || error.message);
    return Promise.reject(error);
  }
);

export default httpClient;