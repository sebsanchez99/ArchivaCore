import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

class FolderDetailsWindow extends StatelessWidget {
  final FolderModel folder;

  const FolderDetailsWindow({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: SchemaColors.neutral100,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_open, color: SchemaColors.primary700, size: 28),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  folder.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            folder.path,
            style: TextStyle(
              color: SchemaColors.textSecondary,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sección de Subcarpetas
              if (folder.subFolders.isNotEmpty) ...[
                _buildSectionHeader(
                    'Subcarpetas', folder.subFolders.length, Icons.folder),
                ...folder.subFolders.map((subfolder) => _buildFolderCard(subfolder)),
                SizedBox(height: 20),
              ],
              // Sección de Archivos
              if (folder.files.isNotEmpty) ...[
                _buildSectionHeader('Archivos', folder.files.length, Icons.insert_drive_file),
                ...folder.files.map((file) => _buildFileCard(file)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cerrar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: SchemaColors.primary700, size: 20),
          SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: SchemaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderCard(FolderModel subfolder) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.folder, color: Colors.amber, size: 36),
        title: Text(
          subfolder.name,
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${subfolder.subFolders.length} subcarpetas, ${subfolder.files.length} archivos',
          style: TextStyle(fontSize: 12, color: SchemaColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildFileCard(FileModel file) {
    IconData fileIcon;
    Color iconColor;
    switch (file.type) {
      case 'pdf':
        fileIcon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'png':
      case 'jpg':
      case 'jpeg':
        fileIcon = Icons.image;
        iconColor = Colors.blue;
        break;
      case 'drawio':
        fileIcon = Icons.edit;
        iconColor = Colors.green;
        break;
      case 'xlsx':
      case 'csv':
        fileIcon = Icons.table_chart;
        iconColor = Colors.teal;
        break;
      case 'pptx':
      case 'ppt':
        fileIcon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      default:
        fileIcon = Icons.insert_drive_file;
        iconColor = SchemaColors.textSecondary;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        leading: Icon(fileIcon, color: iconColor, size: 36),
        title: Text(
          file.name,
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${file.size} MB | ${file.date.substring(0, 10)}',
          style: TextStyle(fontSize: 12, color: SchemaColors.textSecondary),
        ),
      ),
    );
  }
}