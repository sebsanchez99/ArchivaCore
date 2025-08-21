import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/data/services/handler/dio_client.dart';
import 'package:frontend/data/services/handler/dio_handler.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

class AIService {
  final Dio _dio = DioClient().client;

  HttpFuture<ServerResponseModel> analizeHV(String offerText, PlatformFile hvFile) {
    final formData = FormData.fromMap({
      'offerText': offerText,
      'hvFile': MultipartFile.fromBytes(
        hvFile.bytes!,
        filename: hvFile.name
      ),
    });
    return DioHandler.handleRequest(
      () => _dio.post(
        '/microservice/resumenCV',
        data: formData,
        options: Options(contentType: 'multipart/form-data')
      ), 
      (response) => ServerResponseModel.fromJson(response),
    );
  }
}