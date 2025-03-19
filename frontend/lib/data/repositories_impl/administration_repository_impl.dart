import 'package:frontend/data/services/remote/administration_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class AdministrationRepositoryImpl implements AdministrationRepository {
  final AdministrationService _administrationService;

  AdministrationRepositoryImpl(this._administrationService);

  //Método que lista usuarios
  @override
  HttpFuture<ServerResponseModel> getUsers() {
    return _administrationService.getUsers();
  }
  
  //Método que crea usuarios
  @override
  HttpFuture<ServerResponseModel> createUsers(String username, String password, String rolUser) {
    return _administrationService.createUsers(username, password, rolUser);
  }

  //Método que elimina usuarios
  @override
  HttpFuture<ServerResponseModel> deleteUsers(String userID) {
    return _administrationService.deleteUsers(userID);
  }
  
  //Método que actualiza usuarios
  @override
  HttpFuture<ServerResponseModel> putUsers(String userID, String username, String password, String rolUser) {
    return _administrationService.putUsers(userID, username, password, rolUser);
  }
}
