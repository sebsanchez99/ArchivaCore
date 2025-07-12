import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_failure.freezed.dart';

@freezed
class WebSocketFailure with _$WebSocketFailure {
  factory WebSocketFailure.connection() = _Connection;
  factory WebSocketFailure.timeout() = _Timeout;
  factory WebSocketFailure.server() = _Server;
  factory WebSocketFailure.local() = _Local;
}