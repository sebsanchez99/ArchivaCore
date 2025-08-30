import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/file_explorer_tree_view.dart';

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
            return Row(
              children: [
                // Panel izquierdo (árbol de carpetas y archivos)
                SizedBox(
                  width: width * 0.2,
                  height: height * 0.67,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FileExplorerTreeView(bloc: bloc),
                      ),
                    ],
                  ),
                ),

                // Panel derecho (detalle de archivo/carpeta)
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
                              '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // 🔹 Aquí puedes renderizar el detalle dinámico
                            // según el archivo/carpeta seleccionado
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
