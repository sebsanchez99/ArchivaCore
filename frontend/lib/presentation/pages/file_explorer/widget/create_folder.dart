import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';


class CreateFolder extends StatelessWidget {
  const CreateFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Title(
            color: SchemaColors.textPrimary,
            child: Text("Crear Nueva Carpeta"),
          ),
        ],
      ),
    );
  }
}
