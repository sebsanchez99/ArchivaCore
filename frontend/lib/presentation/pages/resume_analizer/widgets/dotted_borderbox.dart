import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DottedBorderbox extends StatelessWidget {
  final void Function(PlatformFile file)? onFilePicked;

  const DottedBorderbox({super.key, this.onFilePicked});

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'], 
    );

    if (result != null && result.files.isNotEmpty) {
      onFilePicked?.call(result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _pickFile(context),
      child: Container(
        width: double.infinity,
        height: 282,
        decoration: BoxDecoration(
          border: Border.all(
            color: SchemaColors.border,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.fileUp,
                size: 48,
                color: SchemaColors.secondary500,
              ),
              const SizedBox(height: 8),
              const Text(
                'Haz clic para seleccionar un archivo',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Formatos permitidos: PDF, DOCX, TXT',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
