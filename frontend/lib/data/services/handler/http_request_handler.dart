import 'dart:async';
import 'package:frontend/domain/either/either.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/typedefs.dart';
import 'package:http/http.dart';

// Función que maneja petición HTTP de manera segura
HttpFuture<T> handleHttpRequest<T>(
  Future<Response> Function() requestFunction,
  FutureOr<T> Function(String responseBody) successHandler,
) async {
  try {
    // Ejecuta la petición HTTP
    final response = await requestFunction();
    if (response.statusCode == 200) {
      return HttpFuture.value(
        Either.right(await successHandler(response.body)),
      );
    }
    if (response.statusCode == 404) {
      throw HttpRequestFailure.notFound();
    }
    if (response.statusCode == 400) {
      throw HttpRequestFailure.badRequest();
    }
    if (response.statusCode == 401) {
      throw HttpRequestFailure.unathorized();
    }
    if (response.statusCode >= 500) {
      throw HttpRequestFailure.server();
    }
    throw HttpRequestFailure.local();
  } catch (e) {
    late HttpRequestFailure failure;
    if (e is HttpRequestFailure) {
      failure = e;
    } else if (e is ClientException) {
      failure = HttpRequestFailure.network();
    } else {
      failure = HttpRequestFailure.local();
    }
    return Either.left(failure);
  }
}
