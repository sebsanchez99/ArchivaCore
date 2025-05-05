import { ref, watch } from "vue";
import type { ValidationErrors, Validators } from "@/interfaces/validationInterfaces.ts";

export function useFormValidation(initialFields: Record<string, string>, validators: Validators = {}) {
  const fields = ref<Record<string, string>>({ ...initialFields });
  const errors = ref<ValidationErrors>({});

  const validateField = (fieldName: string) => {
    const value = fields.value[fieldName];
    const validator = validators[fieldName];
    if (validator) {
      const error = validator(value, fields.value);
      if (error) {
        errors.value[fieldName] = error;
      } else {
        delete errors.value[fieldName];
      }
    }
  };

  const validateAll = () => {
    Object.keys(fields.value).forEach((fieldName) => validateField(fieldName));
    return Object.keys(errors.value).length === 0; // Retorna true si no hay errores
  };

  const setFieldValue = (fieldName: string, value: string) => {
    fields.value[fieldName] = value;
    validateField(fieldName);
  };

  const resetFields = () => {
    fields.value = { ...initialFields };
    errors.value = {};
  };

  const watchFields = () => {
    Object.keys(fields.value).forEach((fieldName) => {
      watch(
        () => fields.value[fieldName],
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