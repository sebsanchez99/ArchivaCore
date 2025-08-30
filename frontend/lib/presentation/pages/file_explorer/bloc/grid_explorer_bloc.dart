import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'grid_explorer_events.dart';
import 'grid_explorer_state.dart';

class GridExplorerBloc extends Bloc<GridExplorerEvents, GridExplorerState> {
  final FileExplorerRepository fileExplorerRepository;

  GridExplorerBloc(GridExplorerState gridExplorerState, {
    required List<FolderModel> rootFolders,
    required this.fileExplorerRepository,
  }) : super(GridExplorerState.initial(rootFolders: rootFolders)) {
    on<UpdateFromExplorer>(_onUpdateFromExplorer);
    on<OpenFolder>(_onOpenFolder);
    on<GoBack>(_onGoBack);
  }

  /// Actualiza el estado desde el bloc general
  void _onUpdateFromExplorer(
      UpdateFromExplorer event, Emitter<GridExplorerState> emit) {
    emit(state.copyWith(
      folders: event.folders.cast<FolderModel>(),
      files: event.files.cast<FileModel>(),
      currentFolder: null,
      navigationStack: [],
      path: event.folders.cast<FolderModel>(), // ruta raíz
    ));
  }

  /// Abre una carpeta y actualiza la vista
  void _onOpenFolder(OpenFolder event, Emitter<GridExplorerState> emit) {
    final folder = event.folder;

    final newStack = List<FolderModel>.from(state.navigationStack);
    if (state.currentFolder != null) {
      newStack.add(state.currentFolder!);
    }

    emit(state.copyWith(
      currentFolder: folder,
      folders: folder.subFolders,
      files: folder.files,
      navigationStack: newStack,
    ));
  }

  /// Vuelve a la carpeta anterior o a la raíz
  void _onGoBack(GoBack event, Emitter<GridExplorerState> emit) {
    if (state.navigationStack.isEmpty) {
      // Volver a la raíz
      emit(state.copyWith(
        currentFolder: null,
        folders: state.path, // carpetas raíz
        files: [],
        navigationStack: [],
      ));
      return;
    }

    final lastFolder = state.navigationStack.last;
    final newStack = List<FolderModel>.from(state.navigationStack)..removeLast();

    emit(state.copyWith(
      currentFolder: lastFolder,
      folders: lastFolder.subFolders,
      files: lastFolder.files,
      navigationStack: newStack,
    ));
  }
}
