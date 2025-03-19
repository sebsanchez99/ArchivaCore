import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Clase que gestiona storage de la aplicaciòn 
class SecureStorage {
  final _storage = FlutterSecureStorage();
  final String _keyToken = 'token';

  //Mètodo que guarda el token
  Future<void> setToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  //Mètodo que obtiene el token
  Future<String?> getToken() async {
    final token = await _storage.read(key: _keyToken);
    return token;
  }

  //Mètodo que elimina el token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
