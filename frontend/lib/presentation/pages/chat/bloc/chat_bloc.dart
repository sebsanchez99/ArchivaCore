import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/enums/connection_status_type.dart';
import 'package:frontend/domain/models/agent_status_model.dart';
import 'package:frontend/domain/models/chat_event_model.dart';
import 'package:frontend/domain/repositories/chat_repository.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_events.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {
  final ChatRepository _chatRepository;

  StreamSubscription<ChatEventModel>? _eventSub;
  StreamSubscription<AgentStatusModel>? _statusSub;
  StreamSubscription<ConnectionStatusType>? _userconnectionStatus;
  final TextEditingController messageController = TextEditingController();

  ChatBloc(super.initialState, {
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository {
    on<ConnectEvent>(_onConnect);
    on<DisconnectEvent>(_onDisconnect);
    on<SendMessageEvent>(_onSendMessage);
    on<ChatEventReceived>(_onChatEventReceived);
    on<AgentStatusUpdated>(_onAgentStatusChanged);
    on<ConnectionStatusChanged>(_onConnectionStatusChanged); 
    on<MessageChanged>(_onMessageChanged); 
  }

  Future<void> _onConnect(ConnectEvent event, Emitter<ChatState> emit) async {
    final result = await _chatRepository.connect(
      event.userId,
      event.role,
      event.companyName,
    );

    emit(result.when(
      left: (failure) => ChatState.loaded(connectionStatus: ConnectionStatusType.connecting(failure: failure)),
      right: (_) {
        _eventSub = _chatRepository.onChatEvent.listen(
          (evt) => add(ChatEvents.chatEventReceived(evt)),
        );
        _statusSub = _chatRepository.onAgentStatus.listen(
          (status) => add(ChatEvents.agentStatusUpdated(status)),
        );
        _userconnectionStatus = _chatRepository.onUserStatusConnection.listen(
          (connected) => add(ChatEvents.connectionStatusChanged(connected)),
        );
        return const ChatState.loaded(connectionStatus: ConnectionStatusType.connected());
      },
    ));
  }

  Future<void> _onDisconnect(DisconnectEvent event, Emitter<ChatState> emit) async {
    await _eventSub?.cancel();
    await _statusSub?.cancel();
    await _userconnectionStatus?.cancel();
    _chatRepository.disconnect();

    state.mapOrNull(
      loaded: (loaded) {
        emit(loaded.copyWith(
          connectionStatus: ConnectionStatusType.disconnected(),
          currentRoom: null,
          agentOnline: false,
          events: [],
          isChatFinalized: true,
        ));
      },
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await _chatRepository.sendMessage(
      event.room,
      event.message,
      event.fromUserId,
    );

    result.when(
      left: (failure) {
        state.mapOrNull(
          loaded: (loaded) => emit(
            loaded.copyWith(errorMessage: failure.toString()),
          ),
        );
      },
      right: (_) {},
    );
  }

  void _onChatEventReceived(ChatEventReceived event, Emitter<ChatState> emit) {
    state.mapOrNull(
      loaded: (loaded) {
        final evt = event.event;
        final updatedEvents = List<ChatEventModel>.from(loaded.events)..add(evt);

        final updated = loaded.copyWith(events: updatedEvents);
        final updatedState = evt.when<ChatState>(
          chatMessage: (_, __) => updated,
          systemMessage: (_, __, ___) => updated,
          assignedAdvisor: (_, room, ___) => updated.copyWith(currentRoom: room),
          info: (_) => updated,
          noAdvisor: (_) => updated.copyWith(agentOnline: false),
          error: (msg) => updated.copyWith(errorMessage: msg),
        );

        emit(updatedState);
      },
    );
  }

  void _onAgentStatusChanged(AgentStatusUpdated event, Emitter<ChatState> emit) {
    state.mapOrNull(
      loaded: (loaded) => emit(loaded.copyWith(agentOnline: event.status.online)),
    );
  }

  void _onConnectionStatusChanged(ConnectionStatusChanged event, Emitter<ChatState> emit) {
    state.mapOrNull(
      loaded: (loaded) => emit(loaded.copyWith(connectionStatus: event.status)),
    );
  }

  void _onMessageChanged(MessageChanged event, Emitter<ChatState> emit) {
    state.mapOrNull(
      loaded: (loaded) => emit(loaded.copyWith(message: event.message)),
    );
  }

  @override
  Future<void> close() {
    _eventSub?.cancel();
    _statusSub?.cancel();
    _userconnectionStatus?.cancel();
    messageController.dispose();
    return super.close();
  }
}
