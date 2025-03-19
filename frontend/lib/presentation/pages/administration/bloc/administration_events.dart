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
    required String userpassword,
  }) = PutUserEvent;

  //Evento que crea a los usuarios
  factory AdministrationEvents.createUsers({
    required String username,
    required String password,
    required String rolUser,
  }) = CreateUserEvent;

  //Evento que elimina a los usuarios
  factory AdministrationEvents.deleteUsers({
    required String userID,
  }) = DeleteUserEvent;
}
