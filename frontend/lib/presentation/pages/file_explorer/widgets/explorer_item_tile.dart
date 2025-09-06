import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';

class ExplorerItemTile extends StatelessWidget {
  final FolderModel? folder;
  final FileModel? file;
  final VoidCallback onTap;

  const ExplorerItemTile({
    super.key,
    this.folder,
    this.file,
    required this.onTap,
  }) : assert(folder != null || file != null, "Debe pasar carpeta o archivo");

  bool get isFolder => folder != null;

  @override
  Widget build(BuildContext context) {
    final iconData = isFolder ? Icons.folder : _iconForFileType(file!.type);
    final iconColor =
        isFolder ? SchemaColors.warning : _colorForFileType(file!.type);

    final name = isFolder ? folder!.name : file!.name;
    final size = isFolder ? "" : "${file!.size} MB";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícono + menú superpuesto
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Ícono con cursor + tooltip
            Tooltip(
              message: name,
              waitDuration: const Duration(milliseconds: 400),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(iconData, size: 50, color: iconColor),
                  ),
                ),
              ),
            ),

            // Menú de opciones
            Positioned(
              right: -10,
              top: -10,
              child: PopupMenuButton<String>(
                tooltip: "Opciones",
                icon: const Icon(Icons.more_horiz, size: 20),
                onSelected: (option) {
                  if (option == 'eliminar') {
                    print("Eliminar $name");
                  } else if (option == 'editar') {
                    showEditFolderDialog(context);
                  } else if (option == 'propiedades') {
                    print("Propiedades de $name");
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Text("Eliminar"),
                      ),
                      const PopupMenuItem(
                        value: 'editar',
                        child: Text("Editar"),
                      ),
                      const PopupMenuItem(
                        value: 'propiedades',
                        child: Text("Propiedades"),
                      ),
                    ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Texto con tooltip
        Tooltip(
          message: name,
          waitDuration: const Duration(milliseconds: 400),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        if (size.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(size, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ],
    );
  }

  IconData _iconForFileType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      case 'mp4':
      case 'mov':
        return Icons.movie;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _colorForFileType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Colors.orange;
      case 'mp4':
      case 'mov':
        return Colors.purple;
      default:
        return SchemaColors.primary;
    }
  }
}
