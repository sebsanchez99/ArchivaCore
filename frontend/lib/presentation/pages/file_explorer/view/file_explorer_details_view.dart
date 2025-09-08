import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/file_explorer_tree_view.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/filedetails.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folder_details.dart'; // Importa el widget de detalles de la carpeta

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
            Widget detailPanel;

            // Lógica para mostrar los detalles del elemento seleccionado
            if (value.selectedFile != null) {
              detailPanel = FileDetails(file: value.selectedFile!, bloc: bloc, isDialog: false);
            } else if (value.selectedFolder != null) {
              detailPanel = FolderDetails(folder: value.selectedFolder!, bloc: bloc, isDialog: false);
            } else {
              // Mensaje cuando no hay nada seleccionado
              detailPanel = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.storage_rounded,
                      size: 80,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Bodega de Archivos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Selecciona un elemento para ver sus detalles.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              width: width * 0.9,
              height: height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Panel izquierdo (árbol de carpetas y archivos)
                  SizedBox(
                    width: width * 0.2,
                    height: height * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: FileExplorerTreeView(bloc: bloc)),
                        ],
                      ),
                    ),
                  ),

                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 1,
                    width: 1,
                    indent: 20,
                    endIndent: 20,
                  ),

                  // Panel derecho (detalle de archivo/carpeta)
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: height * 0.7,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: detailPanel,
                    ),
                  ),
                ],
              ),
            );
          },
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}