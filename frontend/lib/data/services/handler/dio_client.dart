import 'package:dio/dio.dart';
import 'package:frontend/utils/secure_storage.dart';

class DioClient {
  final Dio _dio = Dio();
  final _secureStorage = SecureStorage();

  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
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
      ),
    );
  }

  Dio get client => _dio;

  Future<String?> _getToken() async {
    final token = await _secureStorage.getToken();
    return token;
  }
}
