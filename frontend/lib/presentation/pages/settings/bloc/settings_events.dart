import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_events.freezed.dart';

@freezed
class SettingsEvents with _$SettingsEvents {
  factory SettingsEvents.changePassword() = ChangePasswordEvent;
  factory SettingsEvents.putPasswordField({ required String password }) = PutPasswordFieldEvent;
  factory SettingsEvents.loading({ required bool loading }) = LoadingEvent;
}