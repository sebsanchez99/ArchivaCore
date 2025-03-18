import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

// Definición de interfaz para la autenticación
abstract class AuthRepository {
  // Método abstracto para autenticar usuario
  HttpFuture<ServerResponseModel> logIn(String username, String password);
}

