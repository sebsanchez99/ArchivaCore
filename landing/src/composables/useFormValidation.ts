import { reactive, watch } from "vue";
import type { ValidationErrors, Validators } from "@/interfaces/validationInterfaces.ts";

export function useFormValidation(initialFields: Record<string, string>, validators: Record<string, Array<Function>> = {}) {
  const fields = reactive({ ...initialFields });
  const errors = reactive<ValidationErrors>({});

  const validateField = (fieldName: string) => {
    const value = fields[fieldName];
    const validatorArr = validators[fieldName] || [];
    for (const validator of validatorArr) {
      const error = validator(value, fields);
      if (error) {
        errors[fieldName] = error;
        return;
      }
    }
    delete errors[fieldName];
  };

  const validateAll = () => {
    Object.keys(fields).forEach((fieldName) => validateField(fieldName));
    return Object.keys(errors).length === 0;
  };

  const setFieldValue = (fieldName: string, value: string) => {
    fields[fieldName] = value;
    validateField(fieldName);
  };

  const resetFields = () => {
    Object.assign(fields, initialFields);
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