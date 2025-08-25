import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/presentation/enums/notification_filter.dart';

part 'notification_events.freezed.dart';

@freezed
class NotificationEvents with _$NotificationEvents {
  factory NotificationEvents.initialize() = InititalizeEvent;
  factory NotificationEvents.silentInitialize() = SilentInititalizeEvent;
  factory NotificationEvents.filter({ required NotificationFilter filter }) = FilterEvent;
  factory NotificationEvents.deleteNotification({ required String notificationId }) = DeleteNotificationEvent;
  factory NotificationEvents.deleteAllNotifications() = DeleteAllNotificationsEvent;
  factory NotificationEvents.markNotification({ required String notificationId }) = MarkNotificationEvent;
  factory NotificationEvents.markAllNotifications() = MarkAllNotificationEvent;
  factory NotificationEvents.createNotification({ 
    required String title,
    required String message,
  }) = CreateNotificationEvent;
}