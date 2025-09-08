import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
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

            final base = Theme.of(context);
            final transparentTheme = base.copyWith(
              canvasColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              dividerColor: Colors.transparent,
              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
                thickness: 0,
                space: 0,
              ),
              listTileTheme: const ListTileThemeData(
                tileColor: Colors.transparent,
                selectedTileColor: Colors.transparent,
              ),
              expansionTileTheme: const ExpansionTileThemeData(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                shape: Border(),
                collapsedShape: Border(),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.only(left: 12), 
              ),
            );

            return Theme(
              data: transparentTheme,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  return FolderExpansionTile(folder: folders[index], bloc: bloc);
                },
              ),
            );
          },
          orElse: () => const LoadingState(),
        );
      },
    );
  }
}
