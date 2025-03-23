import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class CreateUserWindow extends StatelessWidget {
  final AdministrationBloc bloc;

  const CreateUserWindow({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: SchemaColors.neutral100,
      title: Text(
        "Crear Nuevo Usuario",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: BlocBuilder<AdministrationBloc, AdministrationState>(
          bloc: bloc,
          builder: (context, state) {
            return state.maybeMap(
              loaded: (value) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Complete el formulario para crear un nuevo usuario en el sistema",
                        style: TextStyle(color: SchemaColors.textSecondary)
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
                        onChanged: (text) => bloc.add(ChangeUsernameEvent(username: text.trim())),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Rol del usuario",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...value.roles.map((role) => RadioListTile<String>(
                        title: Text(role, style: TextStyle(color: SchemaColors.textPrimary)), 
                        value: role, 
                        dense: true,
                        activeColor: SchemaColors.primary700,
                        groupValue: value.selectedRole, 
                        onChanged: (value) => bloc.add(ChangeRoleEvent(role: value!)))
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Contraseña",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      CustomInput(isPassword: true, labeltext: "Contraseña", onChanged: (text) => bloc.add(ChangePasswordEvent(password: text))),
                      SizedBox(height: 20),
                      CustomInput(
                        isPassword: true,
                        labeltext: "Confirmar contraseña",
                      ),
                    ],
                  ),
                );
              },
              orElse: () => LoadingState(),
            );
          },
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          message: 'Crear Usuario',
          onPressed: () async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 200));
            bloc.add(CreateUserEvent());
          },
        ),
      ],
    );
  }
}
