import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final bool iconAtEnd;

  const CustomIconButton({
    super.key,
    required this.message,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.iconSize,
    this.iconAtEnd = false,
    this.backgroundColor = SchemaColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      color: iconColor ?? SchemaColors.neutral,
      size: iconSize ?? 20,
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconAtEnd
            ? [
                Text(message, style: TextStyle(color: SchemaColors.neutral)),
                const SizedBox(width: 8),
                iconWidget,
              ]
            : [
                iconWidget,
                const SizedBox(width: 8),
                Text(message, style: TextStyle(color: SchemaColors.neutral)),
              ],
      ),
    );
  }
}
