import { reactive, watch } from "vue";
import type { ValidationErrors, Validators } from "@/interfaces/validationInterfaces.ts";

export function useFormValidation(initialFields: Record<string, string>, validators: Validators = {}) {
  // Cambiado a reactive para simplificar el acceso a las propiedades
  const fields = reactive({ ...initialFields });
  const errors = reactive<ValidationErrors>({});

  const validateField = (fieldName: string) => {
    const value = fields[fieldName]; // Acceso directo a las propiedades reactivas
    const validator = validators[fieldName];
    if (validator) {
      const error = validator(value, fields);
      if (error) {
        errors[fieldName] = error;
      } else {
        delete errors[fieldName];
      }
    }
  };

  const validateAll = () => {
    Object.keys(fields).forEach((fieldName) => validateField(fieldName));
    return Object.keys(errors).length === 0; // Retorna true si no hay errores
  };

  const setFieldValue = (fieldName: string, value: string) => {
    fields[fieldName] = value;
    validateField(fieldName);
  };

  const resetFields = () => {
    Object.assign(fields, initialFields); // Reinicia los valores de los campos
    Object.keys(errors).forEach((key) => delete errors[key]);
  };

  const watchFields = () => {
    Object.keys(fields).forEach((fieldName) => {
      watch(
        () => fields[fieldName],
        () => validateField(fieldName)
      );
    });
  };

  watchFields();

  return {
    fields,
    errors,
    setFieldValue,
    validateAll,
    resetFields,
  };
}