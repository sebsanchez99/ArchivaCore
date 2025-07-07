// Valida que el campo no esté vacío
export function required(value: string) {
  if (!value || value.trim() === "") return 'Este campo es obligatorio';
  return null;
}

// Valida que el correo sea válido
export function validEmail(value: string) {
  if (!/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(value))
    return "El correo electrónico debe ser válido";
  return null;
}

// Valida que el campo tenga solo letras y espacios, y mínimo 3 caracteres
export function onlyLettersAndSpaces(value: string) {
  if (!/^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$/.test(value))
    return `Este campo solo puede contener letras y espacios`;
  if (value.length < 3)
    return `Este campo debe tener al menos 3 caracteres`;
  return null;
}

// Valida que la contraseña sea fuerte: 8+ caracteres, mayúscula, minúscula, número y caracter especial
export function strongPassword(value: string) {
  if (value.length < 8)
    return "La contraseña debe tener al menos 8 caracteres";
  if (!/[A-Z]/.test(value))
    return "La contraseña debe contener al menos una letra mayúscula";
  if (!/[a-z]/.test(value))
    return "La contraseña debe contener al menos una letra minúscula";
  if (!/[0-9]/.test(value))
    return "La contraseña debe contener al menos un número";
  if (!/[!@#$%^&*(),.?\":{}|<>_\-~[\]\\\/]/.test(value))
    return "La contraseña debe contener al menos un caracter especial";
  return null;
}

// Valida que las contraseñas coincidan
export function passwordsMatch(value: string, fields: Record<string, string>) {
  if (value !== fields.password)
    return "Las contraseñas no coinciden";
  return null;
}
