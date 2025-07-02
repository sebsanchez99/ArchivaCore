import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folder_expansion_tile.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
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
            final folders = value.filteredFolders;
            return Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 125,
                    // width: widtdh * 0.9,
                    child: GridView.count(
                      crossAxisCount: 8,
                      children:
                          folders.map((folder) {
                            // TODO: Calcular tamaño en backend?
                            final totalSize = folder.files.fold<double>(
                              0.0,
                              (sum, file) =>
                                  sum + (double.tryParse(file.size) ?? 0.0),
                            );
                            return Stack(
                              children: [
                                CustomFolder(
                                  icon: Icons.folder,
                                  onPressed: () {},
                                  name: folder.name,
                                  fileCount: folder.files.length.toString(),
                                  size: "${totalSize.toStringAsFixed(2)} MB",
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: PopupMenuButton<String>(
                                    tooltip: 'Opciones',
                                    icon: Icon(Icons.more_horiz, size: 20),
                                    elevation: 7,
                                    color: SchemaColors.background,
                                    onSelected: (String option) {
                                      if (option == 'edit') {
                                        showEditFolderDialog(context);
                                      } else if (option == 'organize') {}
                                    },
                                    itemBuilder:
                                        (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit, size: 20),
                                                    SizedBox(width: 3),
                                                    Text('Editar'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'organize',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.folder_open,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text('Organizar'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Nombre',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Última vez',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Detalles',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ...folders.map(
                      (folder) => FolderExpansionTile(folder: folder),
                    ),
                  ],
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
