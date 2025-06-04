import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DottedBorderbox extends StatelessWidget {
  const DottedBorderbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 282,
      decoration: BoxDecoration(
        border: Border.all(
          color: SchemaColors.border,
          width: 1,
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
            Text(
              'Arrastra y suelta tu archivo aquí',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              'O haz clic para seleccionar un archivo',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Formatos permitidos: PDF, DOCX, DOC, TXT',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}