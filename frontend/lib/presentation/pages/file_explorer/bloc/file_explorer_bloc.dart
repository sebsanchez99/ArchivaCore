import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';

class FileExplorerBloc extends Bloc<FileExplorerEvents, FileExplorerState> {
  FileExplorerBloc(super.initialState) {
    on<InitializeEvent>(_onInitialize);
  }
  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<FileExplorerState> emit,
  ) async {
    emit(FileExplorerState.loaded());
  }
}
