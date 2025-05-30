import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';

// widget de input personalizado
class CustomInput extends StatefulWidget {
  final int? maxLines;
  final String? labeltext;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool isPassword;
  final bool? enabled;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomInput({
    super.key, 
    this.hintText,
    this.labeltext, 
    this.onChanged, 
    this.enabled, 
    this.onSubmitted,
    this.validator, 
    this.controller, 
    this.maxLines,
    required this.isPassword, 
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines ?? 1,
      enabled: widget.enabled, 
      validator: widget.validator,
      // si es un campo de contraseña, ocultar texto
      obscureText: widget.isPassword ? _obscureText : false,
      style: TextStyle(
        color: SchemaColors.textPrimary,
        fontSize: 13
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
        hintText: widget.hintText,
        labelText: widget.labeltext,
        labelStyle: TextStyle(
          color: SchemaColors.textSecondary,
          fontSize: 13
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
        errorStyle: TextStyle(
          color: SchemaColors.error,
          fontSize: 11
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SchemaColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SchemaColors.error),
        ),
        errorMaxLines: 2,
      ),
      cursorErrorColor: SchemaColors.highlight,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,  
    );
  }
}

