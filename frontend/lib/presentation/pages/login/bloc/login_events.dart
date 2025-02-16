import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_events.freezed.dart';

// Eventos de bloc Login
@freezed
class LoginEvents with _$LoginEvents {
  // Evento que se dispara cuando el usuario cambia el nombre de usuario
  factory LoginEvents.usernameChanged(String username) = UsernameChangedEvent;
  // Evento que se dispara cuando el usuario cambia la contraseña
  factory LoginEvents.passwordChanged(String password) = PasswordChangedEvent;
  // Evento que se dispara para habilitar o deshabilitar el bloqueo de la interfaz
  factory LoginEvents.blocking(bool blocking) = BlockingEvent;
}
