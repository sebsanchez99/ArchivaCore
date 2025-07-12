import 'package:frontend/data/services/socket/chat_socket_service.dart';
import 'package:frontend/domain/enums/connection_status_type.dart';
import 'package:frontend/domain/models/agent_status_model.dart';
import 'package:frontend/domain/models/chat_event_model.dart';
import 'package:frontend/domain/repositories/chat_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketService _socketService;

  ChatRepositoryImpl(this._socketService);

  @override
  WSFuture<void> connect(String userId, String role, String? companyName) async {
    return _socketService.connect(userId, role, companyName);
  }

  @override
  Future<void> disconnect() async {
    return _socketService.disconnect();
  }

  @override
  WSFuture<void> sendMessage(String room, String message, String fromUserId) async {
    return _socketService.sendMessage(room, message, fromUserId);
  }

  @override
  
  @override
  Stream<AgentStatusModel> get onAgentStatus => _socketService.onAgentStatus;

  @override
  Stream<ChatEventModel> get onChatEvent => _socketService.onChatEvent;
  
  @override
  Stream<ConnectionStatusType> get onUserStatusConnection => _socketService.onConnectionStatus;
}