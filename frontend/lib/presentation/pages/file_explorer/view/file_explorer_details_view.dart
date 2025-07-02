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
        return Row(
          children: [
            SizedBox(
              width: width * 0.2,
              height: height * 0.67,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        CustomFolder2(
                          leading: Icons.file_copy,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.file_copy,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.file_copy,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.file_copy,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.file_copy,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 1',
                        ),
                        CustomFolder2(
                          leading: Icons.folder,
                          title: 'Documento 2',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.7,
                  height: height * 0.67,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ('Contenido del Archivo/Carpeta'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
