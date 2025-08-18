import 'package:dio/dio.dart';
import 'package:frontend/utils/secure_storage.dart';

/// Clase que crea y configura cliente [Dio]
class DioClient {
  /// Instancia privada de [Dio]
  final Dio _dio = Dio();
  /// Instancia de [SecureStorage]
  final _secureStorage = SecureStorage();

  /// Constructor que configura cliente [Dio]
  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    );
    
    // Interceptor que obtiene y envía token en cada petición HTTP
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

  /// Getter de instancia privada de la clase
  Dio get client => _dio;

  /// Obtiene token del storage
  Future<String?> _getToken() async {
    final token = await _secureStorage.getToken();
    return token;
  }
}
