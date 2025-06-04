// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';

part 'folder_response.freezed.dart';
part 'folder_response.g.dart';

@freezed
class FolderResponse with _$FolderResponse {
  const factory FolderResponse({
    @JsonKey(name: 'carpetas') required List<FolderModel> folders,
    @JsonKey(name: 'archivos') required List<FileModel> files,
  }) = _FolderResponse;

  factory FolderResponse.fromJson(Map<String, dynamic> json) => _$FolderResponseFromJson(json);
}
