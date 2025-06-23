import 'package:frontend/domain/models/role_model.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Repositorio de administración 
abstract class AdministrationRepository {

  /// Método que lista usuarios
  HttpFuture<ServerResponseModel> getUsers();
  /// Método que actualiza a un usuario
  HttpFuture<ServerResponseModel> putUsers(
    String userID,
    String fulname,
    String username,
    String password,
    String idRol,
  );
  /// Método que crea un usuario
  HttpFuture<ServerResponseModel> createUsers(
    String fulname,
    String username,
    String password,
    String idRol,
  );
  /// Método que elimina a un usuario
  HttpFuture<ServerResponseModel> deleteUsers(String userID);

  /// Método que lista usuarios
  Future<List<RoleModel>> getRoles();
}
