import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

// Clase que representa los diferentes tipos de errores que pueden ocurrir al realizar
// una petición HTTP
@freezed
class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.network()  = _Network;
  factory HttpRequestFailure.notFound()  = _NotFound;
  factory HttpRequestFailure.server()  = _Server;
  factory HttpRequestFailure.unauthorized()  = _Unathorized;
  factory HttpRequestFailure.badRequest()  = _BadRequest;
  factory HttpRequestFailure.local()  = _Local;
  factory HttpRequestFailure.expired()  = _Expired;
}