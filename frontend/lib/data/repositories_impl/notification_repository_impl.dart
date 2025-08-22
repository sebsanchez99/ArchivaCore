import 'package:frontend/data/services/remote/notification_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/notification_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepositoryImpl(this._notificationService);

  @override
  HttpFuture<ServerResponseModel> createNotification(String title, String message) async {
    return await _notificationService.createNotifications(title, message);
  }

  @override
  HttpFuture<ServerResponseModel> deleteAllNotification() async {
    return await _notificationService.deleteAllNotifications();
  }

  @override
  HttpFuture<ServerResponseModel> deleteNotification(String notificationId) async {
    return await _notificationService.deleteNotifications(notificationId);

  }

  @override
  HttpFuture<ServerResponseModel> getNotifications() async {
    return await _notificationService.getNotifications();

  }

  @override
  HttpFuture<ServerResponseModel> markNotification(String notificationId) async {
    return await _notificationService.markNotifications(notificationId);

  }
  
}