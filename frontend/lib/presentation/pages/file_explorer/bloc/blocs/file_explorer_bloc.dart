// file_explorer_bloc.dart

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/models/server_response_model.dart';
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
    on<DeleteFileEvent>(_onDeleteFile);
    on<DeleteFolderEvent>(_onDeleteFolder);
    on<PutFolderEvent>(_onPutFolder);
    on<PutFileEvent>(_onPutFile);
    on<CreateFileEvent>(_onCreateFile);
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
            isBusy: false
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

  Future<void> _onCreateFolder(CreateFolderEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    final result = await _fileExplorerRepository.createFolder(event.folderName, event.routefolder);

    await result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (response) async {
        await _refreshContentAndEmit(emit, response: response);
      },
    );
  }

  Future<void> _onDeleteFolder(DeleteFolderEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    final result = await _fileExplorerRepository.moveFolderToRecycle(event.folderPath);

    await result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (response) async {
        await _refreshContentAndEmit(emit, response: response);
      },
    );
  }

  Future<void> _onPutFolder(PutFolderEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    final result = await _fileExplorerRepository.updateFolder(event.folderName, event.currentRoute, event.newRoute);
    await result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (response) async {
        await _refreshContentAndEmit(emit, response: response);
      },
    );
  }

  Future<void> _onPutFile(PutFileEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    final result = await _fileExplorerRepository.updateFile(event.fileName, event.currentRoute, event.newRoute);
    await result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (response) async {
        await _refreshContentAndEmit(emit, response: response);
      },
    );
  }

  Future<void> _onDeleteFile(DeleteFileEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    final result = await _fileExplorerRepository.moveToRecycle(event.filePath);

    await result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (response) async {
        await _refreshContentAndEmit(emit, response: response);
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
      right: (response) async {
        final fileData = response.data as Map<String, dynamic>;
        final rawBuffer = fileData['buffer']['data'] as List<dynamic>;
        final fileName = fileData['fileName'] as String;

        final List<int> buffer = rawBuffer.cast<int>();

        final Uint8List bytes = Uint8List.fromList(buffer);
        
        try {
          final String? filePath = await FilePicker.platform.saveFile(
            fileName: fileName,
            bytes: bytes,
          );

          if (filePath != null) {
            print('Archivo guardado en: $filePath');
          } else {
            print('El usuario canceló la descarga.');
          }
        } catch (e) {
          print('Error al guardar el archivo: $e');
        }
      },
      left: (failure) => emit(FileExplorerState.failed(failure)),
    );
  }

  Future<void> _onCreateFile(CreateFileEvent event, Emitter<FileExplorerState> emit) async {
    final currentState = state.mapOrNull(loaded: (value) => value);
    if (currentState != null) {
      emit(currentState.copyWith(isBusy: true));
    }
    await state.mapOrNull(
      loaded: (value) async{
        final result = await _fileExplorerRepository.createFiles(value.file!, event.folderRoute);
        await result.when(
          left: (failure) {
            emit(FileExplorerState.failed(failure));
          },
          right: (response) async {
            await _refreshContentAndEmit(emit, response: response);
          },
        );
      },
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

  Future<void> _refreshContentAndEmit(Emitter<FileExplorerState> emit, {ServerResponseModel? response}) async {
    final result = await _fileExplorerRepository.getFolders();

    result.when(
      left: (failure) {
        emit(FileExplorerState.failed(failure));
      },
      right: (newContentResponse) {
        final currentState = state.mapOrNull(loaded: (value) => value);
        
        final responseData = newContentResponse.data;
        final newContent = FolderResponse.fromJson(responseData);
        final allTypes = _fileFilter.getAllTypes(newContent);
        final allAuthors = _fileFilter.getAllAuthors(newContent);

        emit(FileExplorerState.loaded(
          content: newContent,
          filteredContent: _fileFilter.applyAllFilters(
            content: newContent,
            query: searchController.text,
            selectedTypes: currentState?.selectedTypes ?? {},
            selectedAuthors: currentState?.selectedAuthors ?? {},
          ),
          allTypes: allTypes,
          allAuthors: allAuthors,
          response: response,
          viewType: currentState?.viewType ?? FileExplorerViewType.grid(),
          isBusy: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}