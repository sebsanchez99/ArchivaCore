//outlined_custom_button.dart
import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class LocationButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;
  final String? selectedPath;

  const LocationButton({
    super.key,
    this.width = 25, 
    this.height = 18,
    required this.text,
    required this.onPressed,
    this.selectedPath,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        side: const BorderSide(color: SchemaColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        selectedPath ?? text,
        style: const TextStyle(
          fontSize: 13,
          color: SchemaColors.textSecondary,
        ),
      ),
    );
  }
}