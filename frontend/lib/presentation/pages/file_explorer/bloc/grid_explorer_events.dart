import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/folder_model.dart';

part 'grid_explorer_events.freezed.dart';

@freezed
class GridExplorerEvents with _$GridExplorerEvents {
  const factory GridExplorerEvents.updateFromExplorer({
    required List<FolderModel> folders,
    required List files,
  }) = UpdateFromExplorer;

  const factory GridExplorerEvents.openFolder(FolderModel folder) = OpenFolder;

  const factory GridExplorerEvents.goBack() = GoBack;
}
