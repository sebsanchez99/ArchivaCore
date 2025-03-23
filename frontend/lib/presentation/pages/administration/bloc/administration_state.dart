import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/models/user_model.dart';

part 'administration_state.freezed.dart';

//Estado del cubit del menú
@freezed
class AdministrationState with _$AdministrationState {
  //Estado de cargando de la vista
  factory AdministrationState.loading() = _LoadingState;
  //Estado de cargado de la vista
  factory AdministrationState.loaded({
    @Default([]) List<UserModel> users,
    @Default([]) List<UserModel> filteredUsers,
    @Default(['Administrador', 'Usuario']) List<String> roles,
    @Default('Usuario') String selectedRole,
    @Default('') String username,
    @Default('') String password,
    ServerResponseModel? response,
  }) = _LoadedState;
  //Estado de fallo
  factory AdministrationState.failed(HttpRequestFailure failure) = _FailedState;
}
