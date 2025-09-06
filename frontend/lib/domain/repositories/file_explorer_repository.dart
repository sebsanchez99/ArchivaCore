import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class FileExplorerRepository {
  HttpFuture<ServerResponseModel> getFolders();
  HttpFuture<ServerResponseModel> createFiles(String fileContent, String folderRoute);
  HttpFuture<ServerResponseModel> downloadFile(String fileRoute);
  HttpFuture<ServerResponseModel> createFolder(String folderName, String routeFolder);
  HttpFuture<ServerResponseModel> updateFolder(String folderName, String currentRoute, String newRoute);
  HttpFuture<ServerResponseModel> updateFile(String fileName, String currentRoute, String newRoute);
  HttpFuture<ServerResponseModel> moveToRecycle(String filePath);
  HttpFuture<ServerResponseModel> moveFolderToRecycle(String folderPath);
} 