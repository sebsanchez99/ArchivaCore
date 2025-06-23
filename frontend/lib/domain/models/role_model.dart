import "package:freezed_annotation/freezed_annotation.dart";

part 'role_model.freezed.dart';
part 'role_model.g.dart';

/// Modelo que representa un usuario 
@freezed
class RoleModel with _$RoleModel {
  factory RoleModel({
    /// Id del usuario
    @JsonKey(name: '_rol_id') required int id,
    /// Nombre del usuario
    @JsonKey(name: '_rol_nombre') required String name,
    /// Rol del usuario
  }) = _RoleModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
}