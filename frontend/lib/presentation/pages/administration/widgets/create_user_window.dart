import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';

class CreateUserWindow extends StatelessWidget {
  const CreateUserWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Crear Nuevo Usuario",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Complete el formulario para crear un nuevo usuario en el sistema",
            ),
            SizedBox(height: 20),
            Text(
              "Nombre de usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            CustomInput(
              labeltext: "Ingrese el nombre de usuario",
              isPassword: false,
            ),
            Text(
              "El nombre de usuario debe tener al menos 3 caracteres y solo puede contener letras, números, guiones y guiones bajos.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              "Rol del usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "El rol determina los permisos que tendrá el usuario en el sistema.",
            ),
            ListTile(
              title: Text("Usuario"),
              subtitle: Text("Acceso básico al sistema"),
              leading: Radio(
                value: "user",
                groupValue: 'role',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text("Administrador"),
              subtitle: Text("Acceso completo al sistema"),
              leading: Radio(
                value: "admin",
                groupValue: 'role',
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 20),
            Text("Contraseña", style: TextStyle(fontWeight: FontWeight.bold)),
            CustomInput(isPassword: true, labeltext: "Contraseña"),
            CustomInput(isPassword: true, labeltext: "Confirmar contraseña"),
          ],
        ),
      ),
      actions: [CustomButton(message: 'Crear Usuario', onPressed: () {})],
    );
  }
}
