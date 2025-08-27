import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/presentation/enums/connection_status_type.dart';
import 'package:frontend/domain/models/chat_event_model.dart';
import 'package:frontend/domain/models/agent_status_model.dart';

part 'chat_events.freezed.dart';

@freezed
class ChatEvents with _$ChatEvents {
  const factory ChatEvents.connect({
    required String userId,
    required String role,
    String? companyName,
  }) = ConnectEvent;

  const factory ChatEvents.disconnect() = DisconnectEvent;

  const factory ChatEvents.sendMessage({
    required String room,
    required String message,
    required String fromUserId,
  }) = SendMessageEvent;

  const factory ChatEvents.chatEventReceived(ChatEventModel event) = ChatEventReceived;

  const factory ChatEvents.agentStatusUpdated(AgentStatusModel status) = AgentStatusUpdated;

  const factory ChatEvents.connectionStatusChanged(ConnectionStatusType status) = ConnectionStatusChanged;
}
