import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';

class CreateUserWindow extends StatelessWidget {
  final AdministrationBloc bloc;

  const CreateUserWindow({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: AlertDialog(
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
                          "Nombre completo",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        CustomInput(
                          labeltext: "Ejemplo: Juan Pérez García",
                          isPassword: false,
                          onChanged: (text) => bloc.add(ChangeFullnameEvent(fullname: text.trim())),
                          validator: (value) => value.validateWith([FormValidator.name()])
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Nombre de usuario",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        CustomInput(
                          labeltext: "Ejemplo: juan.perez",
                          isPassword: false,
                          onChanged: (text) => bloc.add(ChangeUsernameEvent(username: text.trim())),
                          validator: (value) => value.validateWith([FormValidator.username()])
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Rol del usuario",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...value.roles.map((role) => RadioListTile<String>(
                          title: Text(role.name, style: TextStyle(color: SchemaColors.textPrimary)), 
                          value: role.id.toString(), 
                          dense: true,
                          activeColor: SchemaColors.primary700,
                          groupValue: value.selectedRole, 
                          onChanged: (value) => bloc.add(ChangeRoleEvent(role: value!))
                        )
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Contraseña",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        CustomInput(
                          isPassword: true, 
                          labeltext: "Contraseña", 
                          onChanged: (text) => bloc.add(ChangePasswordEvent(password: text)),
                          validator: (value) => value.validateWith([FormValidator.strongPassword()])
                        ),
                        SizedBox(height: 20),
                        CustomInput(
                          isPassword: true,
                          labeltext: "Confirmar contraseña",
                          validator: (value2) => value2.validateWith([
                            FormValidator.match(value.password, message: 'Las contraseñas no coinciden')
                          ]),
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
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 200));
                bloc.add(CreateUserEvent());
              } else {
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
