import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/websocket_failure.dart';

part 'connection_status_type.freezed.dart';

@freezed
class ConnectionStatusType with _$ConnectionStatusType {
  const factory ConnectionStatusType.disconnected() = _Disconnected;
  const factory ConnectionStatusType.connecting({WebSocketFailure? failure}) = _Connecting;
  const factory ConnectionStatusType.connected() = _Connected;
}