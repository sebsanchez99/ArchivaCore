import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/presentation/pages/settings/bloc/settings_events.dart';
import 'package:frontend/presentation/pages/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvents, SettingsState> {
  SettingsBloc( super.initialState, {
    required AuthRepository authRepository
  }) : _authRepository = authRepository {

    on<PutPasswordFieldEvent>(_onPutPasswordField);
    on<LoadingEvent>(_onLoadingEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
  }

  final AuthRepository _authRepository;

  Future<void> _onPutPasswordField(PutPasswordFieldEvent event, Emitter<SettingsState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(password: event.password)),
    );
  }

  Future<void> _onLoadingEvent(LoadingEvent event, Emitter<SettingsState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(loading: event.loading)),
    );
  }

  Future<void> _onChangePasswordEvent(ChangePasswordEvent event, Emitter<SettingsState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        add(LoadingEvent(loading: true));
        final result = await _authRepository.changePassword(value.password);
        emit(
          result.when(
            right: (response) => SettingsState.loaded(response: response), 
            left: (failure) => SettingsState.failed(failure)
          ),
        );
      },
    );
    emit(SettingsState.loaded(loading: false, response: null));
  }
}