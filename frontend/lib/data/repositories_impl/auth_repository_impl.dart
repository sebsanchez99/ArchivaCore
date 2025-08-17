import 'package:frontend/data/services/remote/auth_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/domain/typedefs.dart';

/// Clase que implementa y gestiona operaciones de repositorio [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  /// Instancia de servicio [AuthService]
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  /// Autentica usuario y guarda el token en el storage, retorna un objeto [ServerResponseModel] 
  @override
  HttpFuture<ServerResponseModel> logIn(String username, String password) async {
    return await _authService.authUser(username, password);
  }
  
  @override
  HttpFuture<ServerResponseModel> changePassword(String password) async {
    return await _authService.changePassword(password);
  }
}
