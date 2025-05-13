// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";
import "package:frontend/domain/models/file_model.dart";

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
class FolderModel with _$FolderModel {
  factory FolderModel({
    /// Id de la carpeta
    @JsonKey(name: '_carp_id') required String id,
    /// Nombre de la carpeta
    @JsonKey(name: '_carp_nombre') required String name,
    /// Id del padre de la carpeta
    @JsonKey(name: '_carp_padre_id') required String? parentId,
    /// Id del usuario que creo la carpeta
    /// Este atributo es opcional, ya que puede ser [null] si la carpeta no tiene un usuario asociado
    @JsonKey(name: '_carp_file') required List<FileModel>? files,
    /// Lista de archivos contenidos en la carpeta
    @JsonKey(name: '_usu_id') required String userId,
    /// Nombre del usuario que creo la carpeta
  }) = _FolderModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
  
}