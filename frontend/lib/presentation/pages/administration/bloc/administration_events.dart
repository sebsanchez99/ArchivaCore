import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user_model.dart';

part 'administration_events.freezed.dart';

//Eventos de administrador
@freezed
class AdministrationEvents with _$AdministrationEvents {
  //Evento que lista usuarios
  factory AdministrationEvents.initialize() = InitializeEvent;
  factory AdministrationEvents.filterUsers({required String username}) =
      FilterUsersEvent;

  //Evento que actualiza a los usuarios 
  factory AdministrationEvents.putUsers({
    required UserModel user,
  }) = PutUserEvent;

  //Evento que crea a los usuarios
  factory AdministrationEvents.createUsers() = CreateUserEvent;

  //Evento que elimina a los usuarios
  factory AdministrationEvents.deleteUsers({
    required String userID,
  }) = DeleteUserEvent;

  factory AdministrationEvents.changeRole({
    required String role,
  }) = ChangeRoleEvent;

  factory AdministrationEvents.changePassword({
    required String password,
  }) = ChangePasswordEvent;

  factory AdministrationEvents.changeUsername({
    required String username,
  }) = ChangeUsernameEvent;

  factory AdministrationEvents.changeFullname({
    required String fullname,
  }) = ChangeFullnameEvent;
}
