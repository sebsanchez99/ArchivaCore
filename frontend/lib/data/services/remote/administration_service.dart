import 'package:dio/dio.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Servicio que se encarga de realizar peticiones HTTP para funcionalidades relacionadas
/// con administración
class AdministrationService {
  /// Intancia privada que contiene cliente personalizado de [DioClient]
  final Dio _dio = DioClient().client;

  /// Envía una petición para obtener usuarios de la aplicación y retorna un objeto 
  /// [ServerResponseModel] con el resultado de la operación
  HttpFuture<ServerResponseModel> getUsers() {
    return DioHandler.handleRequest(
      () => _dio.get('/admin/listUsers'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Envía una petición para actualizar un usuario y retorna un objeto 
  /// [ServerResponseModel] con el resultado de la operación
  HttpFuture<ServerResponseModel> putUsers(String userID, String fullname, String username, String password, String idRol) {
    return DioHandler.handleRequest(
      () => _dio.put(
        '/admin/updateUser',
        data: {
          'id' : userID,
          'fullname': fullname,
          'username' : username,
          'password' : password,
          'idRol' : idRol,
        },
      ), 
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Envía una petición para crear un usuario y retorna un objeto 
  /// [ServerResponseModel] con el resultado de la operación
  HttpFuture<ServerResponseModel> createUsers(String fullname, String username, String password, String idRol){
    return DioHandler.handleRequest(
      () => _dio.post(
        '/admin/createUser',
        data: {
          'username' : username,
          'fullname': fullname,
          'password' : password,
          'idRol' : idRol,
        },
      ), 
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Envía una petición para eliminar un usuario y retorna un objeto 
  /// [ServerResponseModel] con el resultado de la operación  
  HttpFuture<ServerResponseModel> deleteUsers(String userID){
    return DioHandler.handleRequest(
    () => _dio.delete(
      '/admin/deleteUser',
      data: {
        'id' : userID,
      },
    ),
    (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Envía una petición para obtener roles
  /// [ServerResponseModel] con el resultado de la operación  
  HttpFuture<ServerResponseModel> getRoles(){
    return DioHandler.handleRequest(
    () => _dio.get('/admin/getRoles'),
    (response) => ServerResponseModel.fromJson(response),
    );
  }
}

