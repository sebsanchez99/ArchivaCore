import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/enums/connection_status_type.dart';
import 'package:frontend/domain/models/chat_event_model.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.loaded({
    @Default(ConnectionStatusType.disconnected()) ConnectionStatusType connectionStatus,
    String? currentRoom,
    @Default([]) List<ChatEventModel> events,
    @Default(false) bool agentOnline,
    @Default(false) bool isChatFinalized,
    String? errorMessage,
    @Default('') String message,
  }) = _LoadedState;
}

