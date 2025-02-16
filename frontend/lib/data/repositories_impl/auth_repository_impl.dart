import 'package:frontend/data/services/remote/auth_service.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/domain/typedefs.dart';

// Implementación de repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  HttpFuture<String> logIn(String username, String password) {
    return _authService.authUser(username, password);
  }
}
