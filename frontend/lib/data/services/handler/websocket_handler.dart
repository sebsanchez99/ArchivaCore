import 'dart:async';
import 'dart:io'; // Para SocketException y HandshakeException

import 'package:frontend/domain/either/either.dart';
import 'package:frontend/domain/failures/websocket_failure.dart';
import 'package:frontend/domain/typedefs.dart';

/// Clase auxiliar para manejar errores de WebSocket
class WebSocketHandler {
  const WebSocketHandler._();

  /// Encapsula una operación WebSocket en un [Either]
  static WSFuture<T> handle<T>(Future<T> Function() action) async {
    final completer = Completer<T>();

    try {
      final result = await action();
      if (!completer.isCompleted) completer.complete(result);
    } catch (e, st) {
      if (!completer.isCompleted) {
        completer.completeError(e, st);
      }
    }

    try {
      final result = await completer.future;
      return Either.right(result);
    } catch (e, st) {
      print('[WebSocketHandler] Error capturado: $e\n$st');
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  /// Mapea cualquier excepción a una [WebSocketFailure]
  static WebSocketFailure _mapExceptionToFailure(Object error) {
    if (error is TimeoutException) return WebSocketFailure.timeout();
    if (error is SocketException || error is HandshakeException) {
      return WebSocketFailure.connection();
    }
    if (error is WebSocketFailure) return error;

    return WebSocketFailure.local();
  }
}
