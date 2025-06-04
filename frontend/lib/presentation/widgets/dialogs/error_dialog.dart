import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

// Diálogo de error
class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Title(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: const Text(
          "Error",
          style: TextStyle(fontSize: 30, color: SchemaColors.error),
        ),
      ),
      content: Text(message, textAlign: TextAlign.center),
      icon: Icon(Icons.cancel_outlined, color: SchemaColors.error, size: 50),
      actions: [
        Center(
          child: CustomButton(
            message: 'Aceptar',
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
