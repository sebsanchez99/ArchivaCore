import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_explorer_view_type.freezed.dart';

@freezed
class FileExplorerViewType with _$FileExplorerViewType {
  const factory FileExplorerViewType.grid() = _Grid;
  const factory FileExplorerViewType.list() = _List;
  const factory FileExplorerViewType.details() = _Details;
}