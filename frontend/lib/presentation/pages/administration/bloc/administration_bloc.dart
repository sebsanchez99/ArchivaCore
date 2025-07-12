import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';

class AdministrationBloc extends Bloc<AdministrationEvents, AdministrationState> {
  final SearchController searchController = SearchController();
  AdministrationBloc( super.initialState, {
    required AdministrationRepository administrationRepository
  }) : _administrationRepository = administrationRepository {

    searchController.addListener(() {
      add(FilterUsersEvent(username: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<FilterUsersEvent>(_onFilterUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<PutUserEvent>(_onPutUser);
    on<DeleteUserEvent>(_onDelete);
    on<ChangeRoleEvent>(_onChangeRole);
    on<ChangeUserStateEvent>(_onChangeUserState);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ChangeUsernameEvent>(_onChangeUsername);
    on<ChangeFullnameEvent>(_onChangeFullname);
  }

  final AdministrationRepository _administrationRepository;

  Future<void> _onInitialize(InitializeEvent event, Emitter<AdministrationState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(AdministrationState.loading()),
    );
    final result = await _administrationRepository.getUsers();
    final roles = await _administrationRepository.getRoles();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data as List<dynamic>;
          final List<UserModel> users = responseData.map((user) => UserModel.fromJson(user)).toList();
          return AdministrationState.loaded(users: users, filteredUsers: users, roles: roles);
        },
        left: (failure) => AdministrationState.failed(failure),
      ),
    );
  }

  Future<void> _onFilterUsers(FilterUsersEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final filteredUsers = value.users.where((user) {
          return user.name.toLowerCase().contains(
            event.username.toLowerCase(),
          );
        }).toList();
        emit(value.copyWith(filteredUsers: filteredUsers));
      },
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<AdministrationState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        emit(AdministrationState.loading());
        final result = await _administrationRepository.createUsers(value.fullname, value.username, value.password, value.selectedRole);
        emit(
          result.when(
            left: (failure) => AdministrationState.failed(failure),
            right: (response) {
              add(AdministrationEvents.initialize());
              return AdministrationState.loaded(response: response);
            },
          ),
        );
      },
    );
  }

  //Método que actualiza a los usuarios
  Future<void> _onPutUser(PutUserEvent event, Emitter<AdministrationState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        emit(AdministrationState.loading());
        final result = await _administrationRepository.putUsers(event.user.id, event.user.fullname, event.user.name, value.password, value.selectedRole);
        emit(
          result.when(
            left: (failure) => AdministrationState.failed(failure),
            right: (response) {
              add(AdministrationEvents.initialize());
              return AdministrationState.loaded(response: response);
            },
          ),
        );
      },
    );
  }

  //Método que elimina a los usuarios
  Future<void> _onDelete(DeleteUserEvent event, Emitter<AdministrationState> emit) async {
    emit(AdministrationState.loading());
    final result = await _administrationRepository.deleteUsers(event.userID);
    emit(
      result.when(
        right: (response) {
          add(AdministrationEvents.initialize());
          return AdministrationState.loaded(response: response);
        },
        left: (failure) => AdministrationState.failed(failure),
      ),
    );
  }

  //Método que actualiza estado de usuario
  Future<void> _onChangeUserState(ChangeUserStateEvent event, Emitter<AdministrationState> emit) async {
    emit(AdministrationState.loading());
    final result = await _administrationRepository.changeUserState(event.userID, event.state);
    emit(
      result.when(
        right: (response) {
          add(AdministrationEvents.initialize());
          return AdministrationState.loaded(response: response);
        },
        left: (failure) => AdministrationState.failed(failure),
      ),
    );
  }

  Future<void> _onChangeRole(ChangeRoleEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(selectedRole: event.role)),
    );
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(password: event.password)),
    );
  }

  Future<void> _onChangeUsername(ChangeUsernameEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(username: event.username)),
    );
  }

  Future<void> _onChangeFullname(ChangeFullnameEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(fullname: event.fullname)),
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
