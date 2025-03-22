import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';

class CreateUserWindow extends StatelessWidget {
  final AdministrationBloc bloc;

  const CreateUserWindow({super.key, required this.bloc});

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
            SizedBox(height: 10),
            Text(
              "Nombre de usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomInput(
              labeltext: "Ingrese el nombre de usuario",
              isPassword: false,
            ),
            SizedBox(height: 10),
            Text(
              "Rol del usuario",
              style: TextStyle(fontWeight: FontWeight.bold),
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
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            SizedBox(height: 20),
            Text("Contraseña", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CustomInput(isPassword: true, labeltext: "Contraseña"),
            SizedBox(height: 20),
            CustomInput(isPassword: true, labeltext: "Confirmar contraseña"),
          ],
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          message: 'Crear Usuario',
          onPressed: () {
            Navigator.pop(context);
            bloc.add(
              CreateUserEvent(
                username: 'admin2',
                password: '12345',
                rolUser: 'Administration',
              ),
            );
          },
        ),
      ],
    );
  }
}
