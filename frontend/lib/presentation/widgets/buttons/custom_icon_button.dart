import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomIconButton extends StatelessWidget {
  final double width;
  final double height;
  final bool disabled;
  final Color backgroundColor;
  final Color? disabledBackgroundColor;
  final VoidCallback? onPressed;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final bool iconAtEnd;

  const CustomIconButton({
    super.key,
    required this.message,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.height = 18,
    this.width = 25,
    this.iconAtEnd = false,
    this.backgroundColor = SchemaColors.primary,
    this.disabled = false,
    this.disabledBackgroundColor,
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
        disabledBackgroundColor: disabledBackgroundColor,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: disabled ? null : onPressed,
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
