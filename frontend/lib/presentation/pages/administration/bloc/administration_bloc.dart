import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';

class AdministrationBloc
    extends Bloc<AdministrationEvents, AdministrationState> {
  final SearchController searchController = SearchController();
  AdministrationBloc(
    super.initialState, {
    required AdministrationRepository administrationRepository,
  }) : _administrationRepository = administrationRepository {

    searchController.addListener(() {
      add(FilterUsersEvent(username: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<FilterUsersEvent>(_onFilterUsers);
    on<CreateUserEvent>(_onCreateUser);
  }

  final AdministrationRepository _administrationRepository;

  Future<void> _onInitialize(InitializeEvent event, Emitter<AdministrationState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(AdministrationState.loading()),
    );
    final result = await _administrationRepository.getUsers();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data as List<dynamic>;
          final List<UserModel> users = responseData.map((user) => UserModel.fromJson(user)).toList();
          return AdministrationState.loaded(users: users, filteredUsers: users);
        },
        left: (failure) => AdministrationState.failed(failure),
      ),
    );
  }

  Future<void> _onFilterUsers( FilterUsersEvent event, Emitter<AdministrationState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final filteredUsers =
            value.users.where((user) {
              return user.name.toLowerCase().contains(
                event.username.toLowerCase(),
              );
            }).toList();
        emit(value.copyWith(filteredUsers: filteredUsers));
      },
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<AdministrationState> emit) async {
    emit(AdministrationState.loading());
    final result = await _administrationRepository.createUsers('admin8', '12345', 'Administrador');
    emit(result.when(
      left: (failure) => AdministrationState.failed(failure),
      right: (response) {
        add(AdministrationEvents.initialize());
        return AdministrationState.loaded(response: response); 
      } 
    ));
  }
}
