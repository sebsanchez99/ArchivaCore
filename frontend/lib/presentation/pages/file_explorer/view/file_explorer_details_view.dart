import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder2.dart';

class FileExplorerDetailsView extends StatelessWidget {
  final FileExplorerBloc bloc;
  const FileExplorerDetailsView({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<FileExplorerBloc, FileExplorerState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeMap(
          loaded: (value) {
            final folders = value.filteredFolders;

            // Construye la lista de widgets para la columna izquierda
            final List<Widget> items = [];
            for (final folder in folders) {
              items.add(
                CustomFolder2(leading: Icons.folder, title: folder.name),
              );
              for (final file in folder.files) {
                items.add(
                  CustomFolder2(leading: Icons.file_copy, title: file.name),
                );
              }
            }

            return Row(
              children: [
                SizedBox(
                  width: width * 0.2,
                  height: height * 0.67,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Expanded(child: ListView(children: items))],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: width * 0.7,
                      height: height * 0.67,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contenido del Archivo/Carpeta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Pendiente: Mostrar detalles del archivo/carpeta seleccionado
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          orElse: () => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
