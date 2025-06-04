import 'package:frontend/data/services/remote/file_explorer_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class FileExplorerRepositoryImpl implements FileExplorerRepository {

  final FileExplorerService _fileExplorerService;

  FileExplorerRepositoryImpl(this._fileExplorerService);

  @override
  HttpFuture<ServerResponseModel> getFolders() {
    return _fileExplorerService.getFolders();
  }
  
}