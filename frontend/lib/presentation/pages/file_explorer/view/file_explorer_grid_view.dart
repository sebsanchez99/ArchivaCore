// file_explorer_grid_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/grid_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/grid_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/grid_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/explorer_item_tile.dart';

class FileExplorerGridView extends StatelessWidget {
  final FileExplorerBloc bloc;
  final GridExplorerBloc gridBloc;

  const FileExplorerGridView({
    super.key,
    required this.gridBloc,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridExplorerBloc, GridExplorerState>(
      bloc: gridBloc,
      builder: (context, state) {
        final currentFolders = state.folders;
        final currentFiles = state.files;

        final isEmpty = currentFolders.isEmpty && currentFiles.isEmpty;

        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: SchemaColors.neutral800
            )
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      state.currentFolder == null ? Icons.home : Icons.arrow_back,
                      color: state.currentFolder == null ? Colors.grey : Colors.black,
                    ),
                    onPressed: state.currentFolder == null ? null : () => gridBloc.add(const GoBack()),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    disabledColor: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text(
                            "Inicio",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          ...[
                            ...state.navigationStack,
                            if (state.currentFolder != null) state.currentFolder!,
                          ].map((folder) {
                            return Row(
                              children: [
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                Text(
                                  folder.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: isEmpty
                    ? Center(
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
                              state.currentFolder == null
                                  ? "No hay elementos en la raíz"
                                  : "Carpeta vacía",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: currentFolders.length + currentFiles.length,
                        itemBuilder: (context, index) {
                          if (index < currentFolders.length) {
                            final folder = currentFolders[index];
                            return ExplorerItemTile(
                              bloc: bloc,
                              folder: folder,
                              onTap: () => gridBloc.add(OpenFolder(folder)),
                            );
                          } else {
                            final file = currentFiles[index - currentFolders.length];
                            return ExplorerItemTile(
                              bloc: bloc,
                              file: file,
                              onTap: () => showFileDetailsDialog(context, file),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}