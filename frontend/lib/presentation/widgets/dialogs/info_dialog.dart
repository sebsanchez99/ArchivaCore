import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

// Diálogo de información
class InfoDialog extends StatelessWidget {
  final VoidCallback onPressed;
  final String message;
  const InfoDialog({super.key, required this.message, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Title(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: const Text(
          "Alerta",
          style: TextStyle(fontSize: 30, color: SchemaColors.info),
        ),
      ),
      content: Text(message, textAlign: TextAlign.center),
      icon: Icon(Icons.info_outline, color: SchemaColors.info, size: 50),
      actions: [
        CustomButton(
          message: 'Aceptar',
          onPressed: () {
            Navigator.of(context).pop();
            onPressed();
          },
        ),
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
