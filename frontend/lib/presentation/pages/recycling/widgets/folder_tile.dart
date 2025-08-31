import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class FolderTile extends StatelessWidget {
  final VoidCallback deleteAction;
  final VoidCallback restoreAction;
  final VoidCallback viewDetailsAction;
  final FolderModel folder;
  final String? userRol;

  const FolderTile({
    super.key, 
    required this.folder, 
    required this.userRol, 
    required this.deleteAction, 
    required this.restoreAction, 
    required this.viewDetailsAction
  });

  @override
  Widget build(BuildContext context) {
    final totalSize = folder.files.fold<double>(
      0.0, (sum, file) => sum + (double.tryParse(file.size) ?? 0.0),
    );
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.amber),
      title: Text(folder.name, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('Tamaño total: ${totalSize.toStringAsFixed(2)} MB.'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Ver detalles',
            icon: const Icon(Icons.remove_red_eye, color: SchemaColors.info),
            onPressed: viewDetailsAction,
          ),
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