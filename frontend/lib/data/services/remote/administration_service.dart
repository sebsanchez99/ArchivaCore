import 'package:dio/dio.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

class AdministrationService {
  final Dio _dio = DioClient().client;

  HttpFuture<ServerResponseModel> getUsers() {
    return DioHandler.handleRequest(
      () => _dio.get('/admin/listUsers'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> putUsers(String userID, String username, String password, String rolUser) {
    return DioHandler.handleRequest(
      () => _dio.put(
        '/admin/updateUser',
        data: {
          'id' : userID,
          'username' : username,
          'password' : password,
          'rolUser' : rolUser,
        },
      ), 
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> createUsers(String username, String password, String rolUser){
    return DioHandler.handleRequest(
      () => _dio.post(
        '/admin/createUser',
        data: {
          'username' : username,
          'password' : password,
          'rolUser' : rolUser,
        },
      ), 
      (response) => ServerResponseModel.fromJson(response),
    );
  }

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
}

