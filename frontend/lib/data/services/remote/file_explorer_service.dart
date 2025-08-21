import 'package:dio/dio.dart';
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

  HttpFuture<ServerResponseModel> createFiles(String fileContent, String folderRoute) {
    return DioHandler.handleRequest(
      () => _dio.post('/supa/createFiles', data: {'fileContent': fileContent, 'folderRoute': folderRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> downloadFile(String fileRoute) {
    return DioHandler.handleRequest(
      () => _dio.get('/supa/downloadFile', queryParameters: {'fileRoute': fileRoute}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> deleteAllFiles(String companyName) {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/deleteAllFiles', data: {'companyName': companyName}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> deleteFile(String fileRoute) {
    return DioHandler.handleRequest(
      () => _dio.delete('/supa/deleteFile', data: {'fileRoute': fileRoute}),
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

  HttpFuture<ServerResponseModel> restoreFromRecycle(String filePath) {
    return DioHandler.handleRequest(
      () => _dio.put('/supa/restoreFromRecycle', data: {'filePath': filePath}),
      (response) => ServerResponseModel.fromJson(response),
    );
  }

  HttpFuture<ServerResponseModel> listRecicle(){
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

}