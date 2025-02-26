import 'package:flutter/material.dart';

// Diálogo de error
class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Title(color: const Color.fromARGB(255, 0, 0, 0), child: const Text("Error", style: TextStyle(fontSize: 30, color: Colors.red))),
      content: Text(message, textAlign: TextAlign.center),
      icon: Icon(Icons.cancel, color: Colors.red, size: 50,),
      actions: [
        Center(
          child: TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
              shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              alignment: Alignment.center,
              backgroundColor: WidgetStateProperty.all(Color(0xFF3A5A98)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Aceptar", style: TextStyle(color: Colors.white, 
           ),
            ),
          ),
        ),
      ],
    );
  }
}
