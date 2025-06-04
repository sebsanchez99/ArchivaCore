import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/login/bloc/login_bloc.dart';
import 'package:frontend/presentation/pages/login/bloc/login_events.dart';
import 'package:frontend/presentation/pages/login/bloc/login_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';
import 'package:frontend/utils/validator/form_validator.dart';

part '../utils/utils.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocProvider(
      create:
          (_) => LoginBloc(
            LoginState(),
            authRepository: context.read<AuthRepository>(),
          ),
      child: Scaffold(
        backgroundColor: SchemaColors.background,
        body: Center(
          child: Container(
            width: 700,
            height: 450,
            decoration: BoxDecoration(
              color: SchemaColors.neutral500,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: SchemaColors.shadow,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: SchemaColors.primary,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logoNombre.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: SchemaColors.background,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: BlocBuilder<LoginBloc, LoginState>(
                        buildWhen:
                            (previous, current) =>
                                previous.blocking != current.blocking,

                        builder: (context, state) => AbsorbPointer(
                              absorbing: state.blocking,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "Iniciar sesión",
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: SchemaColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    CustomInput(
                                      labeltext: 'Usuario',
                                      onChanged: (text) => context.read<LoginBloc>().add(LoginEvents.usernameChanged(text.trim())),
                                      isPassword: false,
                                      validator: (value) => value.validateWith([FormValidator.notEmpty(message: 'El campo usuario no puede estar vacío')]),
                                    ),
                                    CustomInput(
                                      labeltext: 'Contraseña',
                                      onChanged: (text) => context.read<LoginBloc>().add(LoginEvents.passwordChanged(text)),
                                      isPassword: true,
                                      onSubmitted: (_) => _submit(context),
                                      validator: (value) => value.validateWith([FormValidator.notEmpty(message: 'El campo contraseña no puede estar vacío')]),
                                    ),
                                    const SizedBox(height: 10),
                                    state.blocking
                                        ? const Center(
                                          child: CircularProgressIndicator(
                                            color: SchemaColors.primary300,
                                          ),
                                        )
                                        : Builder(
                                          builder: (ctx) {
                                            return SizedBox(
                                              width: double.infinity,
                                              child: CustomButton(
                                                message: 'Iniciar sesión',
                                                onPressed: () {
                                                  if (formKey.currentState!.validate() == true) {
                                                    _submit(context);
                                                  } else {
                                                    return;
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
