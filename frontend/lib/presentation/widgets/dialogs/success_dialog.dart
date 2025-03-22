import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

// Diálogo de éxito
class SuccessDialog extends StatelessWidget {
  final String message;
  const SuccessDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Title(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: const Text(
          "Éxito",
          style: TextStyle(fontSize: 30, color: Colors.green),
        ),
      ),
      content: Text(message, textAlign: TextAlign.center),
      icon: Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
      actions: [
        Center(
          child: CustomButton(
            message: 'Aceptar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
