import 'package:frontend/data/services/remote/administration_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/administration_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class AdministrationRepositoryImpl implements AdministrationRepository {
  final AdministrationService _administrationService;

  AdministrationRepositoryImpl(this._administrationService);
  @override
  HttpFuture<ServerResponseModel> getUsers() {
    return _administrationService.getUsers();
  }
}
