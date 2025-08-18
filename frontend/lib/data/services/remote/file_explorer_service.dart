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

}