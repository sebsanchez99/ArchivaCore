import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';

// widget de input personalizado
class CustomInput extends StatefulWidget {
  final String? labeltext;
  final void Function(String)? onChanged;
  final bool isPassword;
  final bool? enabled;
  final void Function(String)? onSubmitted;
  const CustomInput({
    super.key, 
    this.labeltext, 
    this.onChanged, 
    this.enabled, 
    this.onSubmitted,
    required this.isPassword, 
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      
      enabled: widget.enabled, 
      // si es un campo de contraseña, ocultar texto
      obscureText: widget.isPassword ? _obscureText : false,
      focusNode: FocusNode(),
      style: TextStyle(
        color: SchemaColors.textPrimary,
        fontSize: 15
      ), 
      cursorColor: SchemaColors.textSecondary,
      decoration: InputDecoration(
        isDense: true,
        // si es un campo de contraseña, mostrar icono de visibilidad
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _obscureText? SchemaColors.neutral900 : SchemaColors.primary400,
                ),
                onPressed: () {
                  // cambiar visibilidad del texto
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        labelText: widget.labeltext,
        labelStyle: TextStyle(
          color: SchemaColors.textSecondary,
          fontSize: 15
        ),
        enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: SchemaColors.border), 
        ),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: SchemaColors.primary500),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 14
        ),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,  
    );
  }
}

