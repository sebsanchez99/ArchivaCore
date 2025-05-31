// ignore_for_file: invalid_annotation_target
import "package:freezed_annotation/freezed_annotation.dart";

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed 
class FileModel with _$FileModel {
  factory FileModel({
    /// Id del archivo
    @JsonKey(name: '_file_id') required String id,
    /// Nombre del archivo
    @JsonKey(name: '_file_nombre') required String name,
    /// Tipo de archivo
    @JsonKey(name: '_file_tipo') required String type,
    /// Tamaño del archivo
    @JsonKey(name: '_file_tamano') required String size,
    /// Fecha de creación del archivo
    @JsonKey(name: '_file_fecha_creacion') required String creationDate,
  }) = _FileModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
  
}