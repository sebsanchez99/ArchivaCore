import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Repositorio de administración 
abstract class AdministrationRepository {

  /// Método que lista usuarios
  HttpFuture<ServerResponseModel> getUsers();
  /// Método que actualiza a un usuario
  HttpFuture<ServerResponseModel> putUsers(
    String userID,
    String username,
    String password,
    String rolUser,
  );
  /// Método que crea un usuario
  HttpFuture<ServerResponseModel> createUsers(
    String username,
    String password,
    String rolUser,
  );
  /// Método que elimina a un usuario
  HttpFuture<ServerResponseModel> deleteUsers(String userID);
}
