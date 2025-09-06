import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class FolderExpansionTile extends StatelessWidget {
  final FolderModel folder;
  const FolderExpansionTile({super.key, required this.folder});

  // Definimos iconos y colores por tipo de archivo
  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return Icons.picture_as_pdf;
      case "doc":
      case "docx":
        return Icons.description;
      case "jpg":
      case "png":
      case "jpeg":
        return Icons.image;
      case "mp4":
      case "avi":
        return Icons.movie;
      case "mp3":
      case "wav":
        return Icons.music_note;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return Colors.red;
      case "doc":
      case "docx":
        return Colors.blue;
      case "jpg":
      case "png":
      case "jpeg":
        return Colors.orange;
      case "mp4":
      case "avi":
        return Colors.purple;
      case "mp3":
      case "wav":
        return Colors.green;
      default:
        return SchemaColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //  tenga separación
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        dense: true,
        leading: Icon(Icons.folder, color: SchemaColors.warning, size: 34),
        title: Text(
          folder.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: SchemaColors.textPrimary,
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ), // 🔹 Espaciado interno
        children: [
          ...folder.subFolders.map((sub) => FolderExpansionTile(folder: sub)),
          ...folder.files.map(
            (file) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ), // 🔹 separación archivos
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: Icon(
                  _getFileIcon(file.type),
                  color: _getFileColor(file.type),
                  size: 28,
                ),
                title: Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  file.type,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${file.size} MB",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
