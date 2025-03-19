import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class AdministrationRepository {

  //Método que lista a los usuarios
  HttpFuture<ServerResponseModel> getUsers();
  //Método que actualiza a los usuarios
  HttpFuture<ServerResponseModel> putUsers(
    String userID,
    String username,
    String password,
    String rolUser,
  );
  //Método que crea a los usuarios
  HttpFuture<ServerResponseModel> createUsers(
    String username,
    String password,
    String rolUser,
  );
  //Método que elimina a los usuarios
  HttpFuture<ServerResponseModel> deleteUsers(String userID);
}
