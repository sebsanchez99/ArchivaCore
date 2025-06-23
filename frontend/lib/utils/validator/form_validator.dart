class FormValidator {
  /// Verifica que el campo no esté vacío
  static String? Function(String?) notEmpty({String? message}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'Este campo no puede estar vacío';
      }
      return null;
    };
  }

  /// Valida que sea un correo electrónico válido
  static String? Function(String?) email({String? message}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'Correo no puede estar vacío';
      }
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(value.trim())) {
        return message ?? 'Correo no válido';
      }
      return null;
    };
  }

  /// Valida que el campo tenga un mínimo de caracteres
  static String? Function(String?) minLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.length < length) {
        return message ?? 'Debe tener al menos $length caracteres';
      }
      return null;
    };
  }

  /// Valida que el campo no exceda un máximo de caracteres
  static String? Function(String?) maxLength(int length, {String? message}) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Debe tener máximo $length caracteres';
      }
      return null;
    };
  }

  /// Valida que el campo sea un número
  static String? Function(String?) isNumeric({String? message}) {
    return (value) {
      if (value == null || double.tryParse(value) == null) {
        return message ?? 'Debe ser un número válido';
      }
      return null;
    };
  }

  /// Valida que el valor coincida con otro
  static String? Function(String?) match(String otherValue, {String? message}) {
    return (value) {
      if (value != otherValue) {
        return message ?? 'Los valores no coinciden';
      }
      return null;
    };
  }

  /// Valida con una expresión regular personalizada
  static String? Function(String?) pattern(RegExp regex, {String? message}) {
    return (value) {
      if (value == null || !regex.hasMatch(value)) {
        return message ?? 'Formato inválido';
      }
      return null;
    };
  }

  /// Valida que la contraseña sea fuerte (mínimo 8 caracteres, mayúscula, minúscula, número y símbolo)
  static String? Function(String?) strongPassword({String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message ?? 'La contraseña no puede estar vacía';
      }
  
      final hasUppercase = RegExp(r'[A-Z]');
      final hasLowercase = RegExp(r'[a-z]');
      final hasDigit = RegExp(r'\d');
      final hasSpecialChar = RegExp(r'[!@#\$&*~]');
      final hasMinLength = value.length >= 8;
  
      if (!hasUppercase.hasMatch(value)) {
        return 'Debe tener al menos una letra mayúscula';
      }
      if (!hasLowercase.hasMatch(value)) {
        return 'Debe tener al menos una letra minúscula';
      }
      if (!hasDigit.hasMatch(value)) {
        return 'Debe tener al menos un número';
      }
      if (!hasSpecialChar.hasMatch(value)) {
        return 'Debe tener al menos un carácter especial (!@#\$&*~)';
      }
      if (!hasMinLength) {
        return 'Debe tener al menos 8 caracteres';
      }
  
      return null;
    };
  }

  /// Valida que el nombre de usuario sea válido
  static String? Function(String?) username({String? message}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'El nombre de usuario no puede estar vacío';
      }

      final usernameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9._]{7,}$');

      if (!usernameRegex.hasMatch(value.trim())) {
        return message ??
            'Debe tener al menos 8 caracteres, iniciar con una letra y solo contener letras, números, puntos o guiones bajos';
      }

      return null;
    };
  }

  static String? Function(String?) name({String? message}) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'El nombre no puede estar vacío';
    }
    // Permite letras, espacios y tildes (acentos)
    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return message ?? 'El nombre solo puede contener letras y espacios';
    }
    return null;
  };
}

}
