import 'package:frontend/domain/enums/connection_status_type.dart';
import 'package:frontend/domain/models/agent_status_model.dart';
import 'package:frontend/domain/models/chat_event_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class ChatRepository {
  WSFuture<void> connect(String userId, String role, String? companyName);
  WSFuture<void> sendMessage(String room, String message, String fromUserId);
  Future<void> disconnect();
  
  Stream<ChatEventModel> get onChatEvent;
  Stream<AgentStatusModel> get onAgentStatus;
  Stream<ConnectionStatusType> get onUserStatusConnection; 
}
