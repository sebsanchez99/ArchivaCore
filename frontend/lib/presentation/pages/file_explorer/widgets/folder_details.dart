// folder_details.dart

import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';

class FolderDetails extends StatelessWidget {
  final FolderModel folder;
  final FileExplorerBloc bloc;
  final bool isDialog;

  const FolderDetails({
    super.key,
    required this.folder,
    required this.bloc,
    this.isDialog = true,
  });

  double _calculateFolderSizeKB() {
    final totalSizeMB = folder.files.fold<double>(0.0, (sum, f) => sum + (double.tryParse(f.size) ?? 0.0));
    return totalSizeMB * 1024; 
  }

  int _calculateTotalItems() {
    return folder.files.length + folder.subFolders.length;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFolderHeader(),
              const SizedBox(height: 24),
              _buildFolderProperties(),
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

  Widget _buildFolderHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [SchemaColors.warning, SchemaColors.warning],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.folder,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            folder.name,
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

  Widget _buildFolderProperties() {
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
            _buildDetailRow(
              label: 'Ruta',
              value: folder.path,
            ),
            _buildDetailRow(
              label: 'Elementos',
              value: '${_calculateTotalItems()} item(s)',
            ),
            _buildDetailRow(
              label: 'Tamaño',
              value: '${_calculateFolderSizeKB()} KB',
            ),
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
          onPressed: () => showEditFolderDialog(context, folder, bloc),
          backgroundColor: SchemaColors.primary,
        ),
        CustomIconButton(
          message: 'Eliminar',
          icon: Icons.delete,
          onPressed: () => showDeleteFolderConfirmationDialog(context, folder, bloc),
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
}