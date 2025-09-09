// file_explorer_bloc.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/repositories/file_explorer_repository.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/utils/file_filter.dart';

class FileExplorerBloc extends Bloc<FileExplorerEvents, FileExplorerState> {
  final SearchController searchController = SearchController();

  FileExplorerBloc(
    super.initialState, {
    required FileExplorerRepository fileExplorerRepository,
  }) : _fileExplorerRepository = fileExplorerRepository {
    searchController.addListener(() {
      add(FilterContentEvent(fileName: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<ChangeViewTypeEvent>(_onChangeViewType);
    on<FilterContentEvent>(_onFilterContent);
    on<SelectFileEvent>(_onSelectFile);
    on<SelectFolderEvent>(_onSelectFolder);
    on<UploadFileEvent>(_onUploadFile);
    on<CreateFolderEvent>(_onCreateFolder);
    on<DeleteResponseEvent>(_onDeleteResponse);
    on<DownloadFileEvent>(_onDownloadFile);
    on<FilterByTypesAndAuthorsEvent>(_onFilterByTypesAndAuthors);
  }

  final FileExplorerRepository _fileExplorerRepository;
  final _fileFilter = FileFilter();

  Future<void> _onInitialize(InitializeEvent event, Emitter<FileExplorerState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(FileExplorerState.loading()),
    );
    final result = await _fileExplorerRepository.getFolders();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data;
          FolderResponse content = FolderResponse.fromJson(responseData);
          final allTypes = _fileFilter.getAllTypes(content);
          final allAuthors = _fileFilter.getAllAuthors(content);
          return FileExplorerState.loaded(
            viewType: FileExplorerViewType.grid(),
            content: content,
            filteredContent: content,
            response: null,
            selectedFile: null,
            selectedFolder: null,
            allTypes: allTypes,
            allAuthors: allAuthors,
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
    state.mapOrNull(loaded: (value) => emit(value.copyWith(file: event.result)));
  }

  Future<void> _onFilterContent(FilterContentEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final result = _fileFilter.applyAllFilters(
          content: value.content,
          query: searchController.text,
          selectedTypes: value.selectedTypes,
          selectedAuthors: value.selectedAuthors,
        );
        emit(value.copyWith(filteredContent: result));
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
              add(FileExplorerEvents.initialize());
              return value.copyWith(response: response);
            },
          ),
        );
      },
    );
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

  Future<void> _onDownloadFile(DownloadFileEvent event, Emitter<FileExplorerState> emit) async {
    final result = await _fileExplorerRepository.downloadFile(event.filePath);
    result.when(
      right: (response) {
        print(response);
        final responseData = response.data as String;
        print(responseData);
      },
      left: (failure) => FileExplorerState.failed(failure),
    );
  }

  Future<void> _onFilterByTypesAndAuthors(FilterByTypesAndAuthorsEvent event, Emitter<FileExplorerState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final updatedState = value.copyWith(
          selectedTypes: event.selectedTypes,
          selectedAuthors: event.selectedAuthors,
        );
        final result = _fileFilter.applyAllFilters(
          content: value.content,
          query: searchController.text,
          selectedTypes: event.selectedTypes,
          selectedAuthors: event.selectedAuthors,
        );
        emit(updatedState.copyWith(filteredContent: result));
      },
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}