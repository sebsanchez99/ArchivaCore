// explorer_item_tile.dart

import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';

class ExplorerItemTile extends StatelessWidget {
  final FolderModel? folder;
  final FileModel? file;
  final VoidCallback onTap;
  final FileExplorerBloc bloc; // Add the bloc here

  const ExplorerItemTile({
    super.key,
    this.folder,
    this.file,
    required this.onTap,
    required this.bloc, // Make bloc a required parameter
  }) : assert(folder != null || file != null, "Debe pasar carpeta o archivo");

  bool get isFolder => folder != null;

  @override
  Widget build(BuildContext context) {
    final iconData = isFolder ? Icons.folder : _iconForFileType(file!.type);
    final iconColor = isFolder ? SchemaColors.warning : _colorForFileType(file!.type);

    final name = isFolder ? folder!.name : file!.name;
    final size = isFolder ? "" : "${file!.size} MB";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
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
            Positioned(
              right: -10,
              top: -10,
              child: PopupMenuButton<String>(
                tooltip: "Opciones",
                icon: const Icon(Icons.more_horiz, size: 20),
                onSelected: (option) => _handleMenuOption(context, option),
                itemBuilder: (context) => _menuOptions(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
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

  /// Opciones según si es carpeta o archivo
  List<PopupMenuEntry<String>> _menuOptions() {
    if (isFolder) {
      return const [
        PopupMenuItem(value: 'eliminar', child: Text("Eliminar")),
        PopupMenuItem(value: 'editar', child: Text("Editar")),
        PopupMenuItem(value: 'propiedades', child: Text("Propiedades")),
      ];
    } else {
      return const [
        PopupMenuItem(value: 'eliminar', child: Text("Eliminar")),
        PopupMenuItem(value: 'descargar', child: Text("Descargar")),
        PopupMenuItem(value: 'editar', child: Text("Editar")),
      ];
    }
  }

  /// Manejo centralizado de acciones del menú
  void _handleMenuOption(BuildContext context, String option) {
    if (option == 'eliminar') {
      if (isFolder) {
        showDeleteFolderConfirmationDialog(context, folder!, bloc);
      } else {
        showDeleteFileConfirmationDialog(context, file!, bloc);
      }
    } else if (option == 'editar') {
      if (isFolder) {
        showEditFolderDialog(context, folder!, bloc);
      } else {
        showEditFileDialog(context, file!, bloc);
      }
    } else if (option == 'descargar' && !isFolder) {
      showDownloadFileConfirmationDialog(context, file!, bloc);
    } else if (option == 'propiedades' && isFolder) {
      showFolderDetailsDialog(context, folder!);
    }
  }

  /// Íconos según el tipo de archivo
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

  /// Colores según el tipo de archivo
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