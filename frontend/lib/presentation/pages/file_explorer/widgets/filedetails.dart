import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';

class FileDetails extends StatelessWidget {
  final FileModel file;
  final FileExplorerBloc bloc;
  final bool isDialog;
  const FileDetails({
    super.key,
    required this.file,
    required this.bloc,
    this.isDialog = true,
  });

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileHeader(),
            const SizedBox(height: 24),
            _buildFileProperties(),
            const SizedBox(height: 24),
            _buildSectionTitle('Acciones'),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),

      if (isDialog)
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.close, color: SchemaColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: "Cerrar",
          ),
        ),
    ],
  );
}


  Widget _buildFileHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_getFileColor(file.type), SchemaColors.primary300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getFileIcon(file.type),
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            file.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: SchemaColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFileProperties() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Propiedades'),
            const Divider(thickness: 1, color: SchemaColors.neutral800),
            _buildDetailRow(label: 'Tipo', value: file.type.toUpperCase()),
            _buildDetailRow(label: 'Tamaño', value: '${file.size} KB'),
            _buildDetailRow(label: 'Ruta', value: file.path),
            _buildDetailRow(label: 'Última modificación', value: file.date),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        CustomIconButton(
          message: 'Editar',
          icon: Icons.edit,
          onPressed: () => showEditFileDialog(context, file, bloc),
          backgroundColor: SchemaColors.primary,
        ),
        CustomIconButton(
          message: 'Descargar',
          icon: Icons.download,
          onPressed: () => showDownloadFileConfirmationDialog(context, file, bloc),
          backgroundColor: SchemaColors.info,
        ),
        CustomIconButton(
          message: 'Eliminar',
          icon: Icons.delete,
          onPressed: () => showDeleteFileConfirmationDialog(context, file, bloc),
          backgroundColor: SchemaColors.error,
        ),
      ],
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: SchemaColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: SchemaColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: SchemaColors.primary700,
      ),
    );
  }

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
}
