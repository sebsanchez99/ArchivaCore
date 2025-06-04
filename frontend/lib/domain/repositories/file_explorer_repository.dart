import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class FileExplorerRepository {
  HttpFuture<ServerResponseModel> getFolders();
}