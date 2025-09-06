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
  
  @override
  HttpFuture<ServerResponseModel> createFiles(String fileContent, String folderRoute) {
    return _fileExplorerService.createFiles(fileContent, folderRoute);
  }
  
  @override
  HttpFuture<ServerResponseModel> updateFile(String fileName, String currentRoute, String newRoute) {
    return _fileExplorerService.updateFile(fileName, currentRoute, newRoute);
  }

  @override
  HttpFuture<ServerResponseModel> updateFolder(String folderName, String currentRoute, String newRoute) {
    return _fileExplorerService.updateFolder(folderName, currentRoute, newRoute);
  }

  @override
  HttpFuture<ServerResponseModel> moveToRecycle(String filePath) {
    return _fileExplorerService.moveToRecycle(filePath);
  }

  @override
  HttpFuture<ServerResponseModel> moveFolderToRecycle(String folderPath) {
    return _fileExplorerService.moveFolderToRecycle(folderPath);
  }
  
  @override
  HttpFuture<ServerResponseModel> createFolder(String folderName, String routeFolder) {
    return _fileExplorerService.createFolder(folderName, routeFolder);
  }
  
  @override
  HttpFuture<ServerResponseModel> downloadFile(String fileRoute) {
    return _fileExplorerService.downloadFile(fileRoute);
  }
  
  
}