import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

// Estado de bloc Login
@freezed
class LoginState with _$LoginState {
  // Constructor que define el estado del login con valores predeterminados
  factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool blocking,
  }) = _LoginState;
}