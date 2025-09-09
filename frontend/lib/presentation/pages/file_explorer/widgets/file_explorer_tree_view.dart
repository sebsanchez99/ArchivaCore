// file_explorer_tree_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folder_expansion_tile.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart'; // Importa este archivo si contiene las funciones de diálogo

class FileExplorerTreeView extends StatelessWidget {
 final FileExplorerBloc bloc;
 const FileExplorerTreeView({super.key, required this.bloc});

 @override
 Widget build(BuildContext context) {
  return BlocBuilder<FileExplorerBloc, FileExplorerState>(
   bloc: bloc,
   builder: (context, state) {
    return state.maybeMap(
     loaded: (value) {
      // Extraer las carpetas y los archivos
      final folders = value.filteredContent.folders;
      final files = value.filteredContent.files;

      // Combinar ambas listas y ordenar
      final sortedFolders = [...folders]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      final sortedFiles = [...files]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      final base = Theme.of(context);
      final transparentTheme = base.copyWith(
       canvasColor: Colors.transparent,
       splashColor: Colors.transparent,
       highlightColor: Colors.transparent,
       dividerColor: Colors.transparent,
       dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
       ),
       listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
       ),
       expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: Border(),
        collapsedShape: Border(),
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(left: 12),
       ),
      );

      // Si no hay carpetas ni archivos, mostrar mensaje de vacío
      if (sortedFolders.isEmpty && sortedFiles.isEmpty) {
       return const Center(child: Text("No hay elementos en la raíz."));
      }

      return Theme(
       data: transparentTheme,
       child: ListView(
        padding: EdgeInsets.zero,
        children: [
         ...sortedFolders.map((folder) => FolderExpansionTile(folder: folder, bloc: bloc)),
         ...sortedFiles.map(
          (file) => Padding(
           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
           child: ListTile(
            dense: true,
            leading: Icon(
             getFileIcon(file.type),
             color: getFileColor(file.type),
             size: 28,
            ),
            title: Text(file.name),
            onTap: () => showFileDetailsDialog(context, file),
           ),
          ),
         ),
        ],
       ),
      );
     },
     orElse: () => const LoadingState(),
    );
   },
  );
 }
}