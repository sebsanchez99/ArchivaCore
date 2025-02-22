import 'package:flutter/material.dart';

// widget de input personalizado
class CustomInput extends StatefulWidget {
  final String? labeltext;
  final void Function(String)? onChanged;
  final bool isPassword;
  final void Function(String)? onSubmitted;
  const CustomInput({
    super.key, 
    this.labeltext, 
    this.onChanged, 
    required this.isPassword, 
    this.onSubmitted,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField( 
      // si es un campo de contraseña, ocultar texto
      obscureText: widget.isPassword ? _obscureText : false,
      focusNode: FocusNode(),
      style: TextStyle(
        color: const Color.fromARGB(211, 0, 0, 0),
      ), 
      cursorColor: const Color.fromARGB(110, 0, 0, 0),
      decoration: InputDecoration(
        // si es un campo de contraseña, mostrar icono de visibilidad
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromARGB(255, 150, 150, 150),
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
          color: const Color.fromARGB(211, 0, 0, 0),
        ),
        enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(248, 128, 128, 128)), 
        ),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 150, 150, 150)),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8,
        ),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,  
    );
  }
}

