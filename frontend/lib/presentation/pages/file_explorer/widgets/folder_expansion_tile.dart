// folder_expansion_tile.dart

import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart'; // Importar el archivo de utilidades

class FolderExpansionTile extends StatelessWidget {
 final FolderModel folder;
 final FileExplorerBloc bloc;
 const FolderExpansionTile({
  super.key, 
  required this.folder,
  required this.bloc,
 });

 @override
 Widget build(BuildContext context) {
  final isEmpty = folder.subFolders.isEmpty && folder.files.isEmpty;

  // Ordenar subcarpetas y archivos
  final sortedSubFolders = [...folder.subFolders]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  final sortedFiles = [...folder.files]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  // Lógica para carpetas vacías o con contenido
  if (isEmpty) {
   return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
     dense: true,
     contentPadding: EdgeInsets.zero,
     leading: const Icon(Icons.folder, color: SchemaColors.warning, size: 30),
     title: Tooltip(
      message: folder.name, 
      child: Text(
       folder.name,
       overflow: TextOverflow.ellipsis, 
       maxLines: 1,
       style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: SchemaColors.textPrimary,
       ),
      ),
     ),
     onTap: () {
      bloc.add(FileExplorerEvents.selectFolder(folder: folder));
     },
    ),
   );
  }

  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 6),
   child: Theme(
    data: Theme.of(context).copyWith(
     splashColor: Colors.transparent,
     highlightColor: Colors.transparent,
     hoverColor: Colors.transparent,
    ),
    child: ExpansionTile(
     dense: true,
     tilePadding: EdgeInsets.zero,
     backgroundColor: Colors.transparent,
     collapsedBackgroundColor: Colors.transparent,
     shape: const Border(),
     collapsedShape: const Border(),
     leading: const Icon(Icons.folder, color: SchemaColors.warning, size: 30),
     title: Tooltip(
      message: folder.name, 
      child: Text(
       folder.name,
       overflow: TextOverflow.ellipsis,
       maxLines: 1,
       style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: SchemaColors.textPrimary,
       ),
      ),
     ),
     childrenPadding: const EdgeInsets.only(left: 12),
     children: [
      // Subcarpetas
      ...sortedSubFolders.map((sub) => FolderExpansionTile(folder: sub, bloc: bloc)),
      // Archivos
      ...sortedFiles.map(
       (file) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
         dense: true,
         contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
         ),
         leading: Icon(
          getFileIcon(file.type),
          color: getFileColor(file.type),
          size: 28,
         ),
         title: Tooltip(
          message: file.name, 
          child: Text(
           file.name,
           overflow: TextOverflow.ellipsis,
           maxLines: 1,
           style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
           ),
          ),
         ),
         onTap: () {
          bloc.add(FileExplorerEvents.selectFile(file: file));
         },
        ),
       ),
      ),
     ],
    ),
   ),
  );
 }
}