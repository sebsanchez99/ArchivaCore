import 'dart:async';
import 'package:frontend/data/services/handler/websocket_handler.dart';
import 'package:frontend/presentation/enums/connection_status_type.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:frontend/domain/models/chat_event_model.dart';
import 'package:frontend/domain/models/agent_status_model.dart';
import 'package:frontend/domain/typedefs.dart';
import 'package:frontend/domain/failures/websocket_failure.dart';

class ChatSocketService {
  late IO.Socket _socket;

  StreamController<ChatEventModel>? _chatEventController;
  StreamController<AgentStatusModel>? _agentStatusController;
  StreamController<ConnectionStatusType>? _connectionStatusController;

  void _ensureControllersOpen() {
    _chatEventController ??= StreamController<ChatEventModel>.broadcast();
    _agentStatusController ??= StreamController<AgentStatusModel>.broadcast();
    _connectionStatusController ??= StreamController<ConnectionStatusType>.broadcast();
  }

  WSFuture<void> connect(String userId, String role, String? companyName) {
    return WebSocketHandler.handle(() async {
      _ensureControllersOpen();

      final completer = Completer<void>();

      _socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      _socket.onConnect((_) {
        _connectionStatusController?.add(ConnectionStatusType.connected());
        _socket.emit('join', {
          'userId': userId,
          'role': role,
          'nombreEmpresa': companyName,
        });
        if (!completer.isCompleted) completer.complete();
      });

      _socket.onDisconnect((_) {
        _connectionStatusController?.add(ConnectionStatusType.disconnected());
      });

      _socket.onConnectError((err) {
        if (!completer.isCompleted) {
          _connectionStatusController?.add(
            ConnectionStatusType.connecting(failure: WebSocketFailure.connection()),
          );
          completer.completeError(WebSocketFailure.connection());
        }
      });

      _socket.onError((err) {
        _connectionStatusController?.add(
          ConnectionStatusType.connecting(failure: WebSocketFailure.local()),
        );
      });

      _socket.onReconnectAttempt((_) {
        _connectionStatusController?.add(
          ConnectionStatusType.connecting(),
        );
      });

      _socket.onReconnect((_) {
        _connectionStatusController?.add(ConnectionStatusType.connected());
      });

      _socket.onReconnectError((_) {
        _connectionStatusController?.add(
          ConnectionStatusType.connecting(failure: WebSocketFailure.timeout()),
        );
      });

      _socket.onReconnectFailed((_) {
        _connectionStatusController?.add(
          ConnectionStatusType.disconnected(),
        );
      });

      _socket.connect();

      // Eventos unificados
      final events = [
        'message',
        'system-message',
        'empresa-asignada',
        'asesor-asignado',
        'info',
        'sin-asesor',
        'error',
      ];

      for (final event in events) {
        _listenChatEvent(event);
      }

      _socket.on('agent-status', (data) {
        if (data is List && data.length == 2) {
          _agentStatusController?.add(AgentStatusModel.fromList(data));
          return;
        }
      });

      return completer.future;
    });
  }

  void _listenChatEvent(String event) {
    _listenEvent<Map<String, dynamic>>(event, (data) {
      final parsed = ChatEventModel.parse(data);
      _chatEventController?.add(parsed);
    });
  }

  void _listenEvent<T>(String event, void Function(T data) callback) {
    _socket.on(event, (data) {
      dynamic payload = data;
      if (data is List && data.isNotEmpty) {
        payload = data.first;
      }
      callback(payload);
    });
  }

  WSFuture<void> sendMessage(String room, String message, String fromUserId) {
    return WebSocketHandler.handle(() async {
      _socket.emit('message', {
        'room': room,
        'message': message,
        'fromUserId': fromUserId,
      });
    });
  }

  void disconnect() {
    for (final event in [
      'message',
      'system-message',
      'empresa-asignada',
      'asesor-asignado',
      'info',
      'sin-asesor',
      'error',
      'agent-status',
      'empresa-status',
    ]) {
      _socket.off(event);
    }

    _socket.disconnect();
    _socket.dispose();

    _chatEventController?.close();
    _chatEventController = null;

    _agentStatusController?.close();
    _agentStatusController = null;

    _connectionStatusController?.close();
    _connectionStatusController = null;
  }

  Stream<ChatEventModel> get onChatEvent => _chatEventController!.stream;
  Stream<AgentStatusModel> get onAgentStatus => _agentStatusController!.stream;
  Stream<ConnectionStatusType> get onConnectionStatus => _connectionStatusController!.stream;
}
