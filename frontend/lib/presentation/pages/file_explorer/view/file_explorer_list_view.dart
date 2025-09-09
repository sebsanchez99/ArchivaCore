import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/file_explorer_table.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerListView extends StatelessWidget {
  final FileExplorerBloc bloc;
  const FileExplorerListView({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileExplorerBloc, FileExplorerState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeMap(
          loaded: (value) {
            final folders = value.filteredContent.folders;
            final files = value.filteredContent.files;
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: FolderExpandableTable(
                    folders: folders,
                    files: files,
                    onPreviewFolder: (folder) => showFolderDetailsDialog(context, folder),
                    onPreviewFile: (file) => showFileDetailsDialog(context, file),
                  ),
                ),
              ],
            );
          },
          orElse: () => LoadingState(),
        );
      },
    );
  }
}
