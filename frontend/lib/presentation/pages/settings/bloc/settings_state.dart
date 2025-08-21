import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/server_response_model.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  factory SettingsState.loaded({
    @Default(false) bool loading,
    @Default('') String password,
    ServerResponseModel? response
  }) = _LoadedState;

  factory SettingsState.failed(HttpRequestFailure failure) = _FailedState;
}