import 'package:frontend/domain/either/either.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/failures/websocket_failure.dart';

/// [typedef] que define un alias de future para manejar una petición HTTP
/// Puede retornar un error HTTP [HttpRequestFailure] o el resultado [T]
typedef HttpFuture<T> = Future<Either<HttpRequestFailure, T>>;

typedef WSFuture<T> = Future<Either<WebSocketFailure, T>>;