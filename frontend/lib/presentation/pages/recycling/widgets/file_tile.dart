import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class FileTile extends StatelessWidget {
  final VoidCallback deleteAction;
  final VoidCallback restoreAction;
  final FileModel file;
  final String? userRol;

  const FileTile({
    super.key,
    required this.userRol, 
    required this.file, 
    required this.deleteAction, 
    required this.restoreAction
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
      title: Text(file.name, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('Tamaño: ${file.size} MB.'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Restaurar',
            icon: const Icon(Icons.restore, color: SchemaColors.success),
            onPressed: restoreAction,
          ),
          if(userRol == 'Empresa' || userRol == 'Administrador')
            IconButton(
              tooltip: 'Eliminar definitivamente',
              icon: const Icon(Icons.delete, color: SchemaColors.error),
              onPressed: deleteAction,
            ),
        ],
      ),
    );
  }
}