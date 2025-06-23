import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/user_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_bloc.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_events.dart';
import 'package:frontend/presentation/pages/administration/bloc/administration_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';

//Dialogo para editar un usuario
class EdituserWindow extends StatelessWidget {
  final UserModel user;
  final AdministrationBloc bloc;
  const EdituserWindow({
    super.key, 
    required this.bloc, 
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: AlertDialog(
        title: Text(
          "Editar Usuario",
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
                        "Complete el formulario para editar un usuario en el sistema. Los campos no marcados como obligatorios son opcionales.",
                        style: TextStyle(color: SchemaColors.textSecondary),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nombre completo",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      CustomInput(
                        isPassword: false, 
                        labeltext: user.fullname, 
                        enabled: false,
                      ),
                      Text(
                        "Nombre de usuario",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      CustomInput(
                        isPassword: false, 
                        labeltext: user.name, 
                        enabled: false,
                      ),
                      SizedBox(height: 10),
                      if (user.role.toLowerCase() != 'empresa') ...[
                        Text("Selecciona el rol del usuario (opcional)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...value.roles.map((role) => RadioListTile<String>(
                            title: Text(role.name, style: TextStyle(color: SchemaColors.textPrimary)), 
                            dense: true,
                            value: role.id.toString(), 
                            activeColor: SchemaColors.primary700,
                            groupValue: value.selectedRole, 
                            onChanged: (value) => bloc.add(ChangeRoleEvent(role: value!)))
                          ),
                        SizedBox(height: 7),
                      ],
                      SizedBox(height: 7),
                      Text(
                        "Cambiar contraseña (opcional)",
                        style: TextStyle(fontWeight: FontWeight.bold, height: 3),
                      ),
                      CustomInput(
                        isPassword: true, 
                        labeltext: "Nueva contraseña",
                        onChanged: (text) => bloc.add(ChangePasswordEvent(password: text)),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null; 
                          return value.validateWith([FormValidator.strongPassword()]);
                        },
                      ),
                      SizedBox(height: 16),
                      CustomInput(
                        isPassword: true, 
                        labeltext: "Confirmar contraseña",
                        validator: (value2) {
                          if ((value2 == null || value2.isEmpty) && (value.password.isEmpty)) return null;
                          if (value2 != value.password) return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                    ],
                  ),
                );
                },
                orElse: () => LoadingState()
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
            message: 'Editar Usuario', 
            onPressed: () async {
                if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 200));
                bloc.add(PutUserEvent(user: user));
              } else {
                return;
              }
            } 
          ),
        ],
      ),
    );
  }
}
