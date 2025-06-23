// ignore_for_file: invalid_annotation_target
import "package:freezed_annotation/freezed_annotation.dart";

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modelo que representa un usuario 
@freezed
class UserModel with _$UserModel {
  factory UserModel({
    /// Id del usuario
    @JsonKey(name: '_usu_id') required String id,
    /// Nombre completo de usuario
    @JsonKey(name: '_usu_nombre_completo') required String fullname,
    /// Nombre del usuario
    @JsonKey(name: '_usu_nombre') required String name,
    /// Rol del usuario
    @JsonKey(name: '_rol_nombre') required String role,
    // Id de rol de usuario
    @JsonKey(name: '_rol_id') required int roleId,
    @JsonKey(name: '_usu_activo') required bool active,

  }) = _UserModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
