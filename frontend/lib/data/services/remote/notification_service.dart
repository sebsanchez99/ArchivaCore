import 'package:dio/dio.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

/// Servicio para manejar las notificaciones a través de peticiones HTTP
class NotificationService {
  // Instancia de Dio para realizar las peticiones HTTP
  final Dio _dio = DioClient().client;

  /// Obtiene la lista de notificaciones del servidor
  HttpFuture<ServerResponseModel> getNotifications() {
    return DioHandler.handleRequest(
      () => _dio.get('/notifications/notificationsList'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Marca una notificación como leída o procesada
  HttpFuture<ServerResponseModel> markNotifications(String notificationId) {
    return DioHandler.handleRequest(
      () => _dio.post('/notifications/markNotification', data: {
        'notificationId': notificationId
      }),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Crea una nueva notificación con título y mensaje
  HttpFuture<ServerResponseModel> createNotifications(
      String title, String message) {
    return DioHandler.handleRequest(
      () => _dio.post('/notifications/createNotification',
          data: {'title': title, 'message': message}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Elimina una notificación específica por su ID
  HttpFuture<ServerResponseModel> deleteNotifications(String notificationId) {
    return DioHandler.handleRequest(
      () => _dio.delete('/notifications/deleteNotification',
          data: {'notificationId': notificationId}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  /// Elimina todas las notificaciones del usuario
  HttpFuture<ServerResponseModel> deleteAllNotifications() {
    return DioHandler.handleRequest(
      () => _dio.delete('/notifications/deleteAllNotification'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }
}

