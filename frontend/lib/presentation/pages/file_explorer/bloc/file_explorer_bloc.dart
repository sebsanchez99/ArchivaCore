import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';

class FileExplorerBloc extends Bloc<FileExplorerEvents, FileExplorerState> {
  final SearchController searchController = SearchController();
  FileExplorerBloc(super.initialState, {
    required FileExplorerRepository fileExplorerRepository,
  }) : _fileExplorerRepository = fileExplorerRepository {

    searchController.addListener(() {
      add(FilterFilesEvent(fileName: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<ChangeViewTypeEvent>(_onChangeViewType);
    on<FilterFilesEvent>(_onFilterFiles);
  }
  final FileExplorerRepository _fileExplorerRepository;
  Future<void> _onInitialize(InitializeEvent event, Emitter<FileExplorerState> emit) async {
    final result = await _fileExplorerRepository.getFolders();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data;
          List<FolderModel> folders = (responseData is Map<String, dynamic>) ? FolderResponse.fromJson(responseData).folders : [];
          return FileExplorerState.loaded(viewType: FileExplorerViewType.list(), folders: folders, filteredFolders: folders, response: response);
        }, 
        left: (failure) => FileExplorerState.failed(failure),
      ),
    );

  }

  Future<void> _onChangeViewType(ChangeViewTypeEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(viewType: event.viewType));
      },
    );
  }

  Future<void> _onFilterFiles(FilterFilesEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final filteredFolders = _filterFoldersRecursive(value.folders, event.fileName);
        emit(value.copyWith(filteredFolders: filteredFolders));
      },  
    );
  }

  List<FolderModel> _filterFoldersRecursive(List<FolderModel> folders, String query) {
    final lowerQuery = query.toLowerCase();
    return folders.map((folder) {
      // Filtra subcarpetas recursivamente
      final filteredSubFolders = _filterFoldersRecursive(folder.subFolders, query);
      final matches = folder.name.toLowerCase().contains(lowerQuery) || filteredSubFolders.isNotEmpty;
      if (matches) {
        // Devuelve la carpeta con solo las subcarpetas que coinciden
        return folder.copyWith(subFolders: filteredSubFolders);
      } else {
        return null;
      }
    }).whereType<FolderModel>().toList();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
