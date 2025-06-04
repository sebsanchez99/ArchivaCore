import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class FileExplorerGridView extends StatelessWidget {
  final FileExplorerBloc bloc;
  const FileExplorerGridView({
    super.key, 
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<FileExplorerBloc, FileExplorerState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeMap(loaded: (value) {
          final folders = value.filteredFolders;
          return SizedBox(
            height: height * 0.5,
            width: width * 0.9,
            child: GridView.count(
              crossAxisCount: 7,
              crossAxisSpacing: 5,
              children:
                  folders.map((folder) {
                    final totalSize = folder.files.fold<double>(0.0, (sum, file) => sum + (double.tryParse(file.size) ?? 0.0));
                    return Stack(
                      children: [
                        CustomFolder(
                          icon: Icons.folder,
                          name: folder.name,
                          fileCount: folder.files.length.toString(),
                          size: "${totalSize.toStringAsFixed(2)} MB",
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton<String>(
                            tooltip: 'Opciones',
                            icon: Icon(
                              Icons.more_horiz,
                              size: 20,
                            ),
                            elevation: 7,
                            color: SchemaColors.background,
                            onSelected: (String option) {
                              if (option == 'edit') {
                                // Acción para editar
                                print(
                                  'Editar carpeta: ${folder.name}',
                                );
                              } else if (option ==
                                  'organize') {
                                // Acción para organizar
                                print(
                                  'Organizar carpeta: ${folder.name}',
                                );
                              }
                            },
                            itemBuilder:
                                (
                                  BuildContext context,
                                ) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
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
            );

        },
        orElse: () => LoadingState(),
      );
      }
    );
  }
}