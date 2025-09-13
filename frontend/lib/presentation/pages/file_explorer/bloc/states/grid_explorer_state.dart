import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';

part 'grid_explorer_state.freezed.dart';

@freezed
class GridExplorerState with _$GridExplorerState {
  const factory GridExplorerState({
    required List<FolderModel> folders,
    required List<FileModel> files,
    FolderModel? currentFolder,
    @Default([]) List<FolderModel> navigationStack,
    required List<FolderModel> path,
    required List<FolderModel> rootFolders, 
    @Default([]) List<FileModel> rootFiles, 
  }) = _GridExplorerState;

  factory GridExplorerState.initial({
    List<FolderModel>? rootFolders,
    List<FileModel>? rootFiles,
  }) => GridExplorerState(
        folders: rootFolders ?? [],
        files: [],
        navigationStack: [],
        currentFolder: null,
        path: [],
        rootFolders: rootFolders ?? [],
        rootFiles: rootFiles ?? [],
      );
}
