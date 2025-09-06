import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/explorer_item_tile.dart';

class FileExplorerGridView extends StatelessWidget {
  final FileExplorerBloc bloc;
  final GridExplorerBloc gridBloc;

  const FileExplorerGridView({
    super.key,
    required this.bloc,
    required this.gridBloc,
  });

  @override
  Widget build(BuildContext context) {
    // Carpetas raíz desde el bloc general
    final folders = bloc.state.maybeMap(
      loaded: (value) => List<FolderModel>.from(value.filteredFolders),
      orElse: () => <FolderModel>[],
    );

    // Inicializamos el GridBloc con las carpetas raíz
    gridBloc.add(UpdateFromExplorer(folders: folders, files: []));

    return BlocBuilder<GridExplorerBloc, GridExplorerState>(
      bloc: gridBloc,
      builder: (context, state) {
        final currentFolders = state.folders;
        final currentFiles = state.files;

        final isEmpty = currentFolders.isEmpty && currentFiles.isEmpty;

        return Column(
          children: [
            // Barra de navegación
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    state.currentFolder == null ? Icons.home : Icons.arrow_back,
                    color:
                        state.currentFolder == null
                            ? Colors
                                .grey // home gris decorativo
                            : Colors.black, // back normal
                  ),
                  onPressed:
                      state.currentFolder == null
                          ? null // desactivado en home
                          : () => gridBloc.add(GoBack()),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  disabledColor:
                      Colors.grey, // color fijo cuando está deshabilitado
                ),
                const SizedBox(width: 10),

                // Breadcrumb
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
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Grid o mensaje vacío
            Expanded(
              child:
                  isEmpty
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
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  180, // ancho máximo de cada ítem
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                        itemCount: currentFolders.length + currentFiles.length,
                        itemBuilder: (context, index) {
                          if (index < currentFolders.length) {
                            final folder = currentFolders[index];
                            return ExplorerItemTile(
                              folder: folder,
                              onTap: () => gridBloc.add(OpenFolder(folder)),
                            );
                          } else {
                            final file =
                                currentFiles[index - currentFolders.length];
                            return ExplorerItemTile(
                              file: file,
                              onTap: () {
                                print("Abrir archivo: ${file.name}");
                              },
                            );
                          }
                        },
                      ),
            ),
          ],
        );
      },
    );
  }
}
