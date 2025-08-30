import 'package:frontend/data/services/remote/file_explorer_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/recycle_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class RecycleRepositoryImpl extends RecycleRepository {

  final FileExplorerService _fileExplorerService;

  RecycleRepositoryImpl(this._fileExplorerService);

  @override
  HttpFuture<ServerResponseModel> deleteFile(String filePath) {
    return _fileExplorerService.deleteFileRecycle(filePath);
  }

  @override
  HttpFuture<ServerResponseModel> deleteFolder(String folderPath) {
    return _fileExplorerService.deleteFolder(folderPath);
  }

  @override
  HttpFuture<ServerResponseModel> getRecycleContent() {
    return _fileExplorerService.listRecycle();
  }

  @override
  HttpFuture<ServerResponseModel> restoreFile(String filePath) {
    return _fileExplorerService.restoreFromRecycle(filePath);
  }

  @override
  HttpFuture<ServerResponseModel> restoreFolder(String folderPath) {
    return _fileExplorerService.restoreFolderFromRecycle(folderPath);
  }
  
}