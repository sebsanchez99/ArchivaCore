import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

//Botón personalizado
class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onPressed;
  final String message;
  final Color color;
  final Color textColor;

  const CustomButton({
    super.key,
    this.width = 25, 
    this.height = 18,
    this.color = SchemaColors.primary,
    this.textColor = SchemaColors.neutral,
    required this.message,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onPressed,
      child: Text(message, style: TextStyle(color: textColor)),
    );
  }
}
