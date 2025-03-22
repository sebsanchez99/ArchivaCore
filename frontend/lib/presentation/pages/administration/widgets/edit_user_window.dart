import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';

//Dialogo para editar un usuario
class EdituserWindow extends StatelessWidget {
  const EdituserWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Editar Usuario"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Nombre de usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Selecciona el rol del usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text("Usuario (Acceso básico al sistema)"),
              leading: Radio(
                value: "user",
                groupValue: '',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text("Administrador (Acceso completo al sistema)"),
              leading: Radio(
                value: "admin",
                groupValue: '',
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 7),
            Text(
              "Cambiar contraseña",
              style: TextStyle(fontWeight: FontWeight.bold, height: 3),
            ),
            CustomInput(isPassword: true, labeltext: "Nueva contraseña"),
            SizedBox(height: 16),
            CustomInput(isPassword: true, labeltext: "Confirmar contraseña"),
          ],
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(message: 'Guardar', onPressed: () {}),
      ],
    );
  }
}
