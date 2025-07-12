import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event_model.freezed.dart';
part 'chat_event_model.g.dart';

@freezed
class ChatEventModel with _$ChatEventModel {
  // Mensaje común del chat (usuario o asesor)
  const factory ChatEventModel.chatMessage({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'from') required String from,
  }) = ChatMessage;

  // Mensaje del sistema (desconexión, finalización, etc.)
  const factory ChatEventModel.systemMessage({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'from') required String from,
    @JsonKey(name: 'type') required String type,
  }) = SystemMessage;

  // Asesor asignado al cliente
  const factory ChatEventModel.assignedAdvisor({
    required String asesorId,
    required String room,
    required String msg,
  }) = AssignedAdvisor;

  // Mensaje informativo (general)
  const factory ChatEventModel.info({
    required String msg,
  }) = InfoMessage;

  // No hay asesor disponible
  const factory ChatEventModel.noAdvisor({
    required String msg,
  }) = NoAdvisor;

  // Error general
  const factory ChatEventModel.error({
    required String msg,
  }) = ErrorMessage;

  /// 🔐 No usar este `fromJson`. Usar `parse()` abajo.
  factory ChatEventModel.fromJson(Map<String, dynamic> _) =>
      throw UnimplementedError('Usa ChatEventModel.parse(json)');

  /// ✨ Método unificado para construir el tipo correcto desde un JSON
  static ChatEventModel parse(Map<String, dynamic> json) {
    // 1. Mensaje del sistema
    if (json['from'] == 'system' && json.containsKey('type')) {
      return ChatEventModel.systemMessage(
        message: json['message'] ?? '',
        from: json['from'] ?? 'system',
        type: json['type'] ?? '',
      );
    }

    // 3. Asignación de asesor
    if (json.containsKey('asesorId')) {
      return ChatEventModel.assignedAdvisor(
        asesorId: json['asesorId'],
        room: json['room'] ?? '',
        msg: json['msg'] ?? '',
      );
    }

    // 4. Mensaje sin asesor
    if (json.containsKey('msg') &&
        json['msg'].toString().toLowerCase().contains('no hay agentes')) {
      return ChatEventModel.noAdvisor(msg: json['msg']);
    }

    // 5. Mensaje informativo
    if (json.containsKey('msg')) {
      return ChatEventModel.info(msg: json['msg']);
    }

    // 6. Mensaje común
    if (json.containsKey('message') && json.containsKey('from')) {
      return ChatEventModel.chatMessage(
        message: json['message'],
        from: json['from'],
      );
    }

    // 7. Fallback: error
    return ChatEventModel.error(
      msg: 'Tipo de evento desconocido: ${json.toString()}',
    );
  }
}
