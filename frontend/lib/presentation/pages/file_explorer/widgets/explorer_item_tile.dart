import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final isFolder = folder != null;

    final iconData = isFolder ? Icons.folder : _iconForFileType(file!.type);
    final iconColor = isFolder ? SchemaColors.warning : _colorForFileType(file!.type);

    final name = isFolder ? folder!.name : file!.name;
    final size = isFolder
        ? "${folder!.files.fold<double>(0.0, (sum, f) => sum + (double.tryParse(f.size) ?? 0.0)).toStringAsFixed(2)} MB"
        : "${file!.size} MB";

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 40, color: iconColor),
          const SizedBox(height: 5),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            size,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
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
