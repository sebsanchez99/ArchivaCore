import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/domain/typedefs.dart';
import 'package:frontend/presentation/pages/login/bloc/login_events.dart';
import 'package:frontend/presentation/pages/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  // Se recibe un estado inicial y un repositorio de autenticación
  LoginBloc(super.initialState, {required AuthRepository authRepository})
    : _authRepository = authRepository {
    //Maneja el evento cuando el usuario cambia el nombre de usuario
    on<UsernameChangedEvent>(
      (event, emit) => emit(state.copyWith(username: event.username)),
    );
    //Maneja el evento cuando el usuario cambia la contraseña
    on<PasswordChangedEvent>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    //Maneja el evento cuando se bloquea o se desbloquea la UI
    on<BlockingEvent>(
      (event, emit) => emit(state.copyWith(blocking: event.blocking)),
    );
  }

  final AuthRepository _authRepository;

  // Método para autenticar usuario
  HttpFuture<void> authUser() async {
    add(LoginEvents.blocking(true));
    final result = await _authRepository.logIn(state.username, state.password);
    add(LoginEvents.blocking(false));
    result.whenOrNull(right: (token) => print(token));
    return result;
  }
}
