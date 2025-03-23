import 'package:flutter/material.dart';

//Botón personalizado
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String message;
  const CustomButton({
    super.key, required this.message, required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color( 0xFF3A5A98),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))  
      ),
      onPressed: onPressed,
      child: Text(
        message,
        style: TextStyle(
          color:  Colors.white,
        ),
      ),
    );
  }
}