import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_events.freezed.dart';

@freezed
class NotificationEvents with _$NotificationEvents {
  factory NotificationEvents.initialize() = InititalizeEvent;
  factory NotificationEvents.deleteNotification({ required String notificationId }) = DeleteNotificationEvent;
  factory NotificationEvents.deleteAllNotifications() = DeleteAllNotificationsEvent;
  factory NotificationEvents.markNotification({ required String notificationId }) = MarkNotificationEvent;
}