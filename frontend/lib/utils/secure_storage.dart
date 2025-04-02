import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Clase que gestiona storage de la aplicación 
class SecureStorage {
  /// Instancia de [FlutterSecureStorage]
  final _storage = FlutterSecureStorage();
  /// Llave del storage que contiene el token
  final String _keyToken = 'token';

  /// Guarda el token
  Future<void> setToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Obtiene el token
  Future<String?> getToken() async {
    final token = await _storage.read(key: _keyToken);
    return token;
  }

  /// Elimina el token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
