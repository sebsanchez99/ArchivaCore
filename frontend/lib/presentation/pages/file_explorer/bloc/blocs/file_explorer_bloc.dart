import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';

class FileExplorerBloc extends Bloc<FileExplorerEvents, FileExplorerState> {
  final SearchController searchController = SearchController();

  FileExplorerBloc(
    super.initialState, {
    required FileExplorerRepository fileExplorerRepository,
  }) : _fileExplorerRepository = fileExplorerRepository {
    searchController.addListener(() {
      add(FilterFilesEvent(fileName: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<ChangeViewTypeEvent>(_onChangeViewType);
    on<FilterFilesEvent>(_onFilterFiles);
    on<SelectFileEvent>(_onSelectFile);
    on<SelectFolderEvent>(_onSelectFolder);
    on<UploadFileEvent>(_onUploadFile);
    on<CreateFolderEvent>(_onCreateFolder);
    on<DeleteResponseEvent>(_onDeleteResponse);
  }

  final FileExplorerRepository _fileExplorerRepository;
  
  Future<void> _onInitialize(InitializeEvent event, Emitter<FileExplorerState> emit) async {
    final result = await _fileExplorerRepository.getFolders();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data;
          List<FolderModel> folders = (responseData is Map<String, dynamic>) ? FolderResponse.fromJson(responseData).folders : [];
          return FileExplorerState.loaded(
            viewType: FileExplorerViewType.grid(), 
            folders: folders, 
            filteredFolders: folders, 
            response: null, 
            selectedFile: null,
            selectedFolder: null,
          );
        }, 
        left: (failure) => FileExplorerState.failed(failure),
      ),
    );
  }

  Future<void> _onChangeViewType(
    ChangeViewTypeEvent event,
    Emitter<FileExplorerState> emit,
  ) async {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(viewType: event.viewType));
      },
    );
  }

  Future<void> _onUploadFile(UploadFileEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(file: event.result))
    );
  }

  Future<void> _onFilterFiles(FilterFilesEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final filteredFolders =
            _filterFoldersRecursive(value.folders, event.fileName);
        emit(value.copyWith(filteredFolders: filteredFolders));
      },
    );
  }

  Future<void> _onCreateFolder(
    CreateFolderEvent event,
    Emitter<FileExplorerState> emit,
  ) async {
    await state.mapOrNull(
      loaded: (value) async {
        emit(FileExplorerState.loading());

        final result = await _fileExplorerRepository.createFolder(
          event.folderName,
          event.routefolder,
        );

        emit(
          result.when(
            left: (failure) => FileExplorerState.failed(failure),
            right: (response) {
              // Refresca la lista de carpetas
              add(FileExplorerEvents.initialize());
              return value.copyWith(response: response);
            },
          ),
        );
      },
    );
  }

  List<FolderModel> _filterFoldersRecursive(
    List<FolderModel> folders,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    return folders.map((folder) {
      final filteredSubFolders =
          _filterFoldersRecursive(folder.subFolders, query);
      final matches = folder.name.toLowerCase().contains(lowerQuery) ||
          filteredSubFolders.isNotEmpty;
      if (matches) {
        return folder.copyWith(subFolders: filteredSubFolders);
      } else {
        return null;
      }
    }).whereType<FolderModel>().toList();
  }

  Future<void> _onSelectFile(SelectFileEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(selectedFile: event.file, selectedFolder: null)); 
      },
    );
  }

  Future<void> _onSelectFolder(SelectFolderEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(selectedFolder: event.folder, selectedFile: null)); 
      },
    );
  }

  Future<void> _onDeleteResponse(DeleteResponseEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(response: null)); 
      },
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
