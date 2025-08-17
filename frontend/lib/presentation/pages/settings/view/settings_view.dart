import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/settings/bloc/settings_bloc.dart';
import 'package:frontend/presentation/pages/settings/bloc/settings_events.dart';
import 'package:frontend/presentation/pages/settings/bloc/settings_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/info_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/success_dialog.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

part '../utils/utils.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc(SettingsState.loaded(), authRepository: context.read<AuthRepository>()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          state.mapOrNull(
            loaded: (value) {
              final response = value.response;
              if (response != null) {
                _showResult(context, response);
              }
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<SettingsBloc>();

          return state.map(
            loaded: (value) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(left: 16.0, top: 16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado
                      Row(
                        children: [
                          const Icon(LucideIcons.shield, color: SchemaColors.info),
                          const SizedBox(width: 8),
                          const Text(
                            'Seguridad',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Configuraciones de seguridad y contraseña',
                        style: TextStyle(color: SchemaColors.textSecondary),
                      ),
                      const SizedBox(height: 20),
                
                      // Nueva y confirmar contraseña
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nueva contraseña", style: TextStyle(fontWeight: FontWeight.w500)),
                                SizedBox(height: 8),
                                CustomInput(
                                  isPassword: true,
                                  validator: (text) => text.validateWith([FormValidator.strongPassword()]),
                                  onChanged: (text) => bloc.add(PutPasswordFieldEvent(password: text)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Confirmar contraseña", style: TextStyle(fontWeight: FontWeight.w500)),
                                SizedBox(height: 8),
                                CustomInput(
                                  isPassword: true,
                                  validator: (value2) => value2.validateWith([
                                    FormValidator.match(value.password, message: 'Las contraseña no coinciden')
                                  ]),
                                ),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                  
                      // Recomendaciones
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: SchemaColors.neutral600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(LucideIcons.shieldQuestion, color: SchemaColors.info),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Recomendaciones de seguridad", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text("• Usa al menos 8 caracteres"),
                                  Text("• Incluye mayúsculas, minúsculas y números"),
                                  Text("• Evita información personal"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                  
                      // Botón
                      value.loading 
                      ? LoadingState() 
                      : SizedBox(
                        width: 250,
                        height: 45,
                        child: CustomIconButton(
                          message: 'Cambiar contraseña', 
                          icon: LucideIcons.shieldCheck, 
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _showInfoDialog(context);
                            } else {
                              return;
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, 
            failed: (value) => FailureState(failure: value.failure, onRetry: () {})
          );
        }, 
      ),
    );
  }
}
