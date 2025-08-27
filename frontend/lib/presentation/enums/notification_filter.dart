import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_filter.freezed.dart';

@freezed
class NotificationFilter with _$NotificationFilter  {
  const factory NotificationFilter.all() = _All;
  const factory NotificationFilter.unread() = _Unread;
}