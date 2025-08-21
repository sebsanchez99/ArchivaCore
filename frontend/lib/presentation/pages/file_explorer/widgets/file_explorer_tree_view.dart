import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folder_expansion_tile.dart';

class FileExplorerTreeView extends StatelessWidget {
  final FileExplorerBloc bloc;
  const FileExplorerTreeView({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileExplorerBloc, FileExplorerState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeMap(
          loaded: (value) {
            final folders = value.filteredFolders;

            return ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return FolderExpansionTile(folder: folders[index]);
              },
            );
          },
          orElse: () => const LoadingState(),
        );
      },
    );
  }
}
