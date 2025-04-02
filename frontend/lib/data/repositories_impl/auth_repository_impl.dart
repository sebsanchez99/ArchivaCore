import 'package:frontend/data/services/remote/auth_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/domain/typedefs.dart';
import 'package:frontend/utils/secure_storage.dart';

/// Clase que implementa y gestiona operaciones de repositorio [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  /// Instancia de servicio [AuthService]
  final AuthService _authService;
  /// Instancia de [SecureStorage]
  final _secureStorage = SecureStorage();

  AuthRepositoryImpl(this._authService);

  /// Autentica usuario y guarda el token en el storage, retorna un objeto [ServerResponseModel] 
  @override
  HttpFuture<ServerResponseModel> logIn(
    String username,
    String password,
  ) async {
    final result = await _authService.authUser(username, password);
    result.whenOrNull(
      right: (response) async {
        final token = response.data;
        await _secureStorage.setToken(token);
      },
    );
    return result;
  }
}
