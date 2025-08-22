import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class NotificationRepository {
  HttpFuture<ServerResponseModel> getNotifications();
  HttpFuture<ServerResponseModel> deleteNotification(String notificationId);
  HttpFuture<ServerResponseModel> deleteAllNotification();
  HttpFuture<ServerResponseModel> markNotification(String notificationId);
  HttpFuture<ServerResponseModel> createNotification(String title, String message);
}