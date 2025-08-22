import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class RecycleRepository {
  HttpFuture<ServerResponseModel> getRecycleContent();
  HttpFuture<ServerResponseModel> deleteFolder(String folderPath);
  HttpFuture<ServerResponseModel> deleteFile(String filePath);
  HttpFuture<ServerResponseModel> restoreFile(String filePath);
  HttpFuture<ServerResponseModel> restoreFolder(String folderPath);
}