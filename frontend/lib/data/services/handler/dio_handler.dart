import 'dart:async';
import 'package:dio/dio.dart';
import 'package:frontend/domain/either/either.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/typedefs.dart';

class DioHandler {
  // Constructor privado: evita que se instancie la clase, ya que todo se accede de forma estática.
  const DioHandler._(); 

  // Maneja una solicitud HTTP usando Dio y encapsula el resultado en un Either.
  static HttpFuture<T> handleRequest<T>(
    Future<Response<dynamic>> Function() requestFunction,
    FutureOr<T> Function(dynamic responseBody) successHandler,
  ) async {
    try {
      final response = await requestFunction();
      final statusCode = response.statusCode ?? 0;

      if (_isSuccessStatus(statusCode)) {
        final data = response.data;
        if (data == null) return Either.left(HttpRequestFailure.local());
        final result = await successHandler(data);
        return Either.right(result);
      } else {
        return Either.left(_mapStatusToFailure(statusCode));
      }
    } catch (e) {
      HttpRequestFailure failure;

      if (e is DioException) {
        failure = _mapDioExceptionToFailure(e);
      } else if (e is HttpRequestFailure) {
        failure = e;
      } else {
        failure = HttpRequestFailure.local();
      }

      return Either.left(failure);
    }
  }

  /// Verifica si el código de estado HTTP indica éxito.
  static bool _isSuccessStatus(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Mapea un código de estado HTTP a un tipo específico de HttpRequestFailure.
  static HttpRequestFailure _mapStatusToFailure(int statusCode) {
    if (statusCode == 400) return HttpRequestFailure.badRequest();
    if (statusCode == 401) return HttpRequestFailure.unauthorized();
    if (statusCode == 404) return HttpRequestFailure.notFound();
    if (statusCode >= 500) return HttpRequestFailure.server();
    return HttpRequestFailure.local();
  }

  /// Mapea un DioException a un HttpRequestFailure según el tipo de error.
  static HttpRequestFailure _mapDioExceptionToFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return HttpRequestFailure.network(); // Error de red o timeout.
      case DioExceptionType.badResponse:
        return _mapStatusToFailure(e.response?.statusCode ?? 0);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      default:
        return HttpRequestFailure.local(); // Otro error no clasificado.
    }
  }
}
