import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

class FileExplorerService {

  final Dio _dio = DioClient().client;

  HttpFuture<ServerResponseModel> getFolders() {
    return DioHandler.handleRequest(
      () => _dio.get('/supa/listFoldersForUser'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> createFiles(PlatformFile file, String folderRoute, String fileName) {
    final formData = FormData.fromMap({
      'folderRoute': folderRoute,
      'fileContent': MultipartFile.fromBytes(
        file.bytes!,
        filename: fileName
      ),
    });
    return DioHandler.handleRequest(
      () => _dio.post(
        '/supa/createFile', 
        data: formData,
        options: Options(contentType: 'multipart/form-data')        
      ),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> downloadFile(String fileRoute) {
    return DioHandler.handleRequest(
      () => _dio.get('/supa/downloadFile', data: {'fileRoute': fileRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> emptyRecycleFolder() {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/emptyRecycleFolder'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> deleteFile(String fileRoute) {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/deleteFile', data: {'fileRoute': fileRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> deleteFolder(String folderPath) {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/deleteFolderFromRecycle', data: {'folderPath': folderPath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> createFolder(String folderName, String routeFolder) {
    return DioHandler.handleRequest(
      () => _dio.post('/supa/createFolder', data: {'folderName': folderName, 'routeFolder': routeFolder}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> moveToRecycle(String filePath) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/moveToRecycle', data: {'filePath': filePath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> moveFolderToRecycle(String folderPath) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/moveFolderToRecycle', data: {'folderPath': folderPath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> restoreFromRecycle(String filePath) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/restoreFromRecycle', data: {'filePath': filePath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> restoreFolderFromRecycle(String folderPath) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/restoreFolderFromRecycle', data: {'folderPath': folderPath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> listRecycle(){
    return DioHandler.handleRequest(
      () => _dio.get('/supa/listRecicle'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> deleteFileRecycle(String fileRoute) {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/deleteFileRecycle', data: {'fileRoute': fileRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> listAllRoutes(){
    return DioHandler.handleRequest(
      () => _dio.get('/supa/listAllRoutes'),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> updateFile(String fileName, String currentRoute, String newRoute) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/updateFile', data: {'fileName': fileName, 'currentRoute': currentRoute, 'newRoute': newRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> updateFolder(String folderName, String currentRoute, String newRoute) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/updateFolder', data: {'folderName': folderName, 'currentRoute': currentRoute, 'newRoute': newRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }
}