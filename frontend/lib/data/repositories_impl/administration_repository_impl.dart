import 'package:frontend/data/services/remote/administration_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/domain/typedefs.dart';

/// Clase que implementa y gestiona operaciones de repositorio [AdministrationRepository]
class AdministrationRepositoryImpl implements AdministrationRepository {
  /// Instancia de servicio [AdministrationService] 
  final AdministrationService _administrationService;

  AdministrationRepositoryImpl(this._administrationService);

  /// Lista usuarios y retorna un objeto [ServerResponseModel]
  @override
  HttpFuture<ServerResponseModel> getUsers() {
    return _administrationService.getUsers();
  }
  
  /// Crea un usuario y retorna un objeto [ServerResponseModel]
  @override
  HttpFuture<ServerResponseModel> createUsers(String username, String password, String rolUser) {
    return _administrationService.createUsers(username, password, rolUser);
  }

  /// Elimina un usuario y retorna un objeto [ServerResponseModel]
  @override
  HttpFuture<ServerResponseModel> deleteUsers(String userID) {
    return _administrationService.deleteUsers(userID);
  }
  
  /// Actualiza los datos de un usuario y retorna un objeto [ServerResponseModel]
  @override
  HttpFuture<ServerResponseModel> putUsers(String userID, String username, String password, String rolUser) {
    return _administrationService.putUsers(userID, username, password, rolUser);
  }
}
