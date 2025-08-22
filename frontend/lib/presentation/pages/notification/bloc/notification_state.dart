import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/notification_model.dart';
import 'package:frontend/domain/models/server_response_model.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  factory NotificationState.loading() = _LoadingState;
  factory NotificationState.loaded({
    @Default([]) List<NotificationModel> notifications,
    ServerResponseModel? response,
  }) = _LoadedState;
  factory NotificationState.failed(HttpRequestFailure failure) = _FailedState;

}