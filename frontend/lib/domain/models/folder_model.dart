// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";
import "package:frontend/domain/models/file_model.dart";

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
class FolderModel with _$FolderModel {
  factory FolderModel({
    /// Id de la carpeta
    @JsonKey(name: 'nombreCarpeta') required String name,
    /// Nombre de la carpeta
    @JsonKey(name: 'archivos') required List<FileModel> files,
    /// Id del padre de la carpeta
    @JsonKey(name: 'subCarpeta') required List<FolderModel> subFolders,
  }) = _FolderModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
  
}