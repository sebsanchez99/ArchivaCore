import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/grid_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/explorer_item_tile.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

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
    gridBloc.add(UpdateFromExplorer(
      folders: folders,
      files: [],
    ));

    return BlocBuilder<GridExplorerBloc, GridExplorerState>(
      bloc: gridBloc,
      builder: (context, state) {
        final currentFolders = state.folders;
        final currentFiles = state.files;

        return Column(
          children: [
            // Barra de navegación
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    state.currentFolder == null
                        ? Icons.home
                        : Icons.arrow_back,
                  ),
                  onPressed: () => gridBloc.add(GoBack()),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.currentFolder?.name ?? 'Raíz',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Grid de carpetas y archivos
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: [
                  // Carpetas
                  ...currentFolders.map((folder) {
                    final totalSize = folder.files.fold<double>(
                      0.0,
                      (sum, f) => sum + (double.tryParse(f.size) ?? 0.0),
                    );

                    return ExplorerItemTile(
                      folder: folder,
                      onTap: () => gridBloc.add(OpenFolder(folder)),
                    );
                  }),
                  // Archivos
                  ...currentFiles.map((file) => ExplorerItemTile(
                        file: file,
                        onTap: () {
                          print("Abrir archivo: ${file.name}");
                          // Aquí puedes agregar acción de abrir archivo
                        },
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
