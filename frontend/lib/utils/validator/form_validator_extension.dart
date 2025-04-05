extension FormValidatorExtension on String? {
  /// Ejecuta una lista de validadores secuencialmente.
  /// Devuelve el primer error encontrado o null si todos pasan.
  String? validateWith(List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(this);
      if (error != null) return error;
    }
    return null;
  }
}
