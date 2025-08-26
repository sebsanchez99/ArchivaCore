import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/repositories/recycle_repository.dart';
import 'package:frontend/presentation/pages/recycling/bloc/recycle_events.dart';
import 'package:frontend/presentation/pages/recycling/bloc/recycle_state.dart';

class RecycleBloc extends Bloc<RecycleEvents, RecycleState> {
  final SearchController searchController = SearchController();
  RecycleBloc(super.initialState, {
    required RecycleRepository recycleRepository,
  }) : _recycleRepository = recycleRepository{
    searchController.addListener(() {
      add(FilterContentEvent(elementName: searchController.text));
    });

    on<InitializeEvent>(_onInitialize);
    on<FilterContentEvent>(_onFilterContent);
    on<RestoreFileEvent>(_onRestoreFile);
    on<RestoreFolderEvent>(_onRestoreFolder);
    on<DeleteFileEvent>(_onDeleteFile);
    on<DeleteFolderEvent>(_onDeleteFolder);
  }

  final RecycleRepository _recycleRepository;

  Future<void> _onInitialize(InitializeEvent event, Emitter<RecycleState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(RecycleState.loading()),
    );
    final result = await _recycleRepository.getRecycleContent();
    emit(
      result.when(
        right: (response) {
          final responseData = FolderResponse.fromJson(response.data);
          return RecycleState.loaded(content: responseData, filteredContent: responseData);
        }, 
        left: (failure) => RecycleState.failed(failure),
      ),
    );
  }
  
  Future<void> _onFilterContent(FilterContentEvent event, Emitter<RecycleState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        final elementName = event.elementName.toLowerCase();
        final filteredFolders = value.content.folders.where((folder) => folder.name.toLowerCase().contains(elementName)).toList();
        final filteredFiles = value.content.files.where((file) => file.name.toLowerCase().contains(elementName)).toList();
        final filteredContent = FolderResponse(files: filteredFiles, folders: filteredFolders);
        emit(value.copyWith(filteredContent: filteredContent));
      },
    );
  }

  Future<void> _onRestoreFile(RestoreFileEvent event, Emitter<RecycleState> emit) async {
    emit(RecycleState.loading());
    final result = await _recycleRepository.restoreFile(event.filePath);
    emit(
      result.when(
        right: (response) {
          if(response.result) {
            add(RecycleEvents.initialize());
            return RecycleState.loaded(response: response);
          } else {
            return RecycleState.failed(HttpRequestFailure.server());
          } 
        }, 
        left: (failure) => RecycleState.failed(failure),
      ),
    );
  }

  Future<void> _onRestoreFolder(RestoreFolderEvent event, Emitter<RecycleState> emit) async {
    emit(RecycleState.loading());
    final result = await _recycleRepository.restoreFolder(event.folderPath);
    emit(
      result.when(
        right: (response) {
          if(response.result) {
            add(RecycleEvents.initialize());
            return RecycleState.loaded(response: response);
          } else {
            return RecycleState.failed(HttpRequestFailure.server());
          }
        }, 
        left: (failure) => RecycleState.failed(failure),
      ),
    );
  }

  Future<void> _onDeleteFile(DeleteFileEvent event, Emitter<RecycleState> emit) async {
    emit(RecycleState.loading());
    final result = await _recycleRepository.deleteFile(event.filePath);
    emit(
      result.when(
        right: (response) {
          if (response.result) {
            add(RecycleEvents.initialize());
            return RecycleState.loaded(response: response);
          } else {
            return RecycleState.failed(HttpRequestFailure.server());
          }
        }, 
        left: (failure) => RecycleState.failed(failure),
      ),
    );
  }
  
  Future<void> _onDeleteFolder(DeleteFolderEvent event, Emitter<RecycleState> emit) async {
    emit(RecycleState.loading());
    final result = await _recycleRepository.deleteFolder(event.folderPath);
    emit(
      result.when(
        right: (response) {
          if (response.result) {
            add(RecycleEvents.initialize());
            return RecycleState.loaded(response: response);
          } else {
            return RecycleState.failed(HttpRequestFailure.server());
          }
        }, 
        left: (failure) => RecycleState.failed(failure),
      ),
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}