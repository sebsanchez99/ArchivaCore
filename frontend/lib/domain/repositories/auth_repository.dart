import 'package:frontend/domain/typedefs.dart';

// Definición de interfaz para la autenticación
abstract class AuthRepository {
  // Método abstracto para autenticar usuario
  HttpFuture<String> logIn(String username, String password);
}
