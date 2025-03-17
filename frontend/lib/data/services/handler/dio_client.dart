import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  Dio get client => _dio;

  // TODO: Implementar flutter_secure_storage
  Future<String?> _getToken() async {
    return 'token';
  }
}