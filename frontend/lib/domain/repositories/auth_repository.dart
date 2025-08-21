import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Repositorio de autenticación
abstract class AuthRepository {
  /// Método que autentica un usuario
  HttpFuture<ServerResponseModel> logIn(String username, String password);

  HttpFuture<ServerResponseModel> changePassword(String password);
}

