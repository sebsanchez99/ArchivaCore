// ignore_for_file: invalid_annotation_target
import "package:freezed_annotation/freezed_annotation.dart";

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed 
class FileModel with _$FileModel {
  factory FileModel({
    /// Id del archivo
    @JsonKey(name: 'nombreArchivo') required String name,
    /// Nombre del archivo
    @JsonKey(name: 'tamanoMB') required String size,
    /// Tipo de archivo
    @JsonKey(name: 'fecha') required String date,
    /// Tamaño del archivo
    @JsonKey(name: 'tipo') required String type,
  }) = _FileModel;

  /// Parsea los datos de la respuesta de tipo JSON y los transforma en un dato de tipo [Map]
  factory FileModel.fromJson(Map<String, dynamic> json) => _$FileModelFromJson(json);
  
}