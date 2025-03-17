// Servicio de autenticación que maneja solicitudes HTTP usando Dio
import 'package:dio/dio.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

// Servicio de autenticación 
class AuthService {

  final Dio _dio = DioClient().client;

  // Método para autenticar usuario con nombre de usuario y contraseña
  HttpFuture<ServerResponseModel> authUser(String username, String password) {
    return DioHandler.handleRequest(
      () => _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      ),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

}
