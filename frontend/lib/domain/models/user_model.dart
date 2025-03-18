// ignore_for_file: invalid_annotation_target
import "package:freezed_annotation/freezed_annotation.dart";

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// Clase que representa un usuario en la aplicación
@freezed
class UserModel with _$UserModel {
  factory UserModel({
    // id del usuario
    @JsonKey(name: '_usu_id') required String id,
    // Nombre del usuario
    @JsonKey(name: '_usu_nombre') required String name,
    // Rol del usuario
    @JsonKey(name: '_rol_nombre') required String role,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
