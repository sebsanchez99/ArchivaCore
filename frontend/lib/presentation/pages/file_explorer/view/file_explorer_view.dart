import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';

class FileExplorerView extends StatelessWidget {
  const FileExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FileExplorerBloc>(
      create:
          (_) =>
              FileExplorerBloc(FileExplorerState.loading())
                ..add(InitializeEvent()),
    child: BlocConsumer<FileExplorerBloc, FileExplorerState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        return state.map(
          loading: (_) => Center(), 
          loaded: (value) {
            return Center(child: Text('Explorador de archivos'),);
          }, 
          failed: (_) => Center(),
          );
      }, 
      )
    );
  }
}
