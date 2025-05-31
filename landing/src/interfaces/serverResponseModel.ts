export interface ServerResponseModel<T = any> {
    result: boolean; // Indica si la operación fue exitosa
    message: string; // Mensaje del servidor
    data: T; // Datos de la operación (puede ser de cualquier tipo)
  }