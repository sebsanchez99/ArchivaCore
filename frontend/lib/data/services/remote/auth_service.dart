import 'package:dio/dio.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Servicio que se encarga de realizar peticiones HTTP para funcionalidades relacionadas
/// con autorización
class AuthService {
  /// Intancia privada que contiene cliente personalizado de [DioClient]
  final Dio _dio = DioClient().client;

  /// Envía una petición para autenticar un usuario y retorna un objeto 
  /// [ServerResponseModel] con el resultado de la operació
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
