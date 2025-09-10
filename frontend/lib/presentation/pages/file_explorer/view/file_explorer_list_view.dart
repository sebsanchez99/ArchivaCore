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
            final isEmpty = folders.isEmpty && files.isEmpty;
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: !isEmpty 
                  ?  FolderExpandableTable(
                      folders: folders,
                      files: files,
                      onPreviewFolder: (folder) => showFolderDetailsDialog(context, folder),
                      onPreviewFile: (file) => showFileDetailsDialog(context, file),
                    )
                  : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_open,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No hay elementos por mostrar.",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
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
