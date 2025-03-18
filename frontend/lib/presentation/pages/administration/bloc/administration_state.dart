import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user_model.dart';

part 'administration_state.freezed.dart';

//Estado del cubit del menú
@freezed
class AdministrationState with _$AdministrationState {
  factory AdministrationState.loading() = _LoadingState;
  factory AdministrationState.loaded({
    @Default([]) List<UserModel> users,
    @Default([]) List<UserModel> filteredUsers,
  }) = _LoadedState;
}
