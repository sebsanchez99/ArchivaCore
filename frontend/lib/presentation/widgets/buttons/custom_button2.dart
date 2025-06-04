import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String message;
  const CustomButton2({
    super.key,
    required this.onPressed,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: SchemaColors.neutral,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(message, style: TextStyle(color: SchemaColors.textPrimary)),
    );
  }
}
