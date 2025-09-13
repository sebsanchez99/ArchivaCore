import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/file_model.dart';
import '../events/grid_explorer_events.dart';
import '../states/grid_explorer_state.dart';

class GridExplorerBloc extends Bloc<GridExplorerEvents, GridExplorerState> {
  GridExplorerBloc(super.initialState) {
    on<UpdateFromExplorer>(_onUpdateFromExplorer);
    on<OpenFolder>(_onOpenFolder);
    on<GoBack>(_onGoBack);
  }

  /// Actualiza el estado desde el bloc general
  void _onUpdateFromExplorer(
    UpdateFromExplorer event,
    Emitter<GridExplorerState> emit,
  ) {
    if (state.currentFolder == null) {
      // Refrescar en raíz
      emit(
        state.copyWith(
          folders: event.folders.cast<FolderModel>(),
          files: event.files.cast<FileModel>(),
          currentFolder: null,
          navigationStack: [],
          path: event.folders.cast<FolderModel>(),
          rootFolders: event.folders.cast<FolderModel>(),
          rootFiles:
              event.files.cast<FileModel>(), // ✅ guardamos los archivos raíz
        ),
      );
    } else {
      // Refrescar dentro de la carpeta actual
      final updatedFolder = event.folders.cast<FolderModel>().firstWhere(
        (f) => f.name == state.currentFolder!.name,
        orElse: () => state.currentFolder!,
      );

      emit(
        state.copyWith(
          currentFolder: updatedFolder,
          folders: updatedFolder.subFolders,
          files: updatedFolder.files,
          // mantenemos navigationStack y path como están
        ),
      );
    }
  }

  /// Abre una carpeta y actualiza la vista
  void _onOpenFolder(OpenFolder event, Emitter<GridExplorerState> emit) {
    final folder = event.folder;

    final newStack = List<FolderModel>.from(state.navigationStack);
    if (state.currentFolder != null) {
      newStack.add(state.currentFolder!);
    }

    emit(
      state.copyWith(
        currentFolder: folder,
        folders: folder.subFolders,
        files: folder.files,
        navigationStack: newStack,
      ),
    );
  }

  /// Vuelve a la carpeta anterior o a la raíz
  void _onGoBack(GoBack event, Emitter<GridExplorerState> emit) {
    if (state.navigationStack.isEmpty) {
      // Volver a la raíz
      emit(
        state.copyWith(
          currentFolder: null,
          folders: state.rootFolders, // ✅ restauramos carpetas raíz
          files: state.rootFiles, // ✅ restauramos archivos raíz
          navigationStack: [],
        ),
      );
      return;
    }

    final lastFolder = state.navigationStack.last;
    final newStack = List<FolderModel>.from(state.navigationStack)
      ..removeLast();

    emit(
      state.copyWith(
        currentFolder: lastFolder,
        folders: lastFolder.subFolders,
        files: lastFolder.files,
        navigationStack: newStack,
      ),
    );
  }
}
