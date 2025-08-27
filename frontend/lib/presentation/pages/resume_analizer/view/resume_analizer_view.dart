import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/ai_repository.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/resume_analizer/widgets/cv_analysis_card.dart';
import 'package:frontend/presentation/pages/resume_analizer/widgets/dotted_borderbox.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_bloc.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_events.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_state.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';
import 'package:lucide_icons/lucide_icons.dart';

part '../utils/utils.dart';

class ResumeAnalizerView extends StatelessWidget {
  const ResumeAnalizerView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocProvider<ResumeAnalizerBloc>(
      create:
          (context) => ResumeAnalizerBloc(
            ResumeAnalizerState.loaded(),
            aiRepository: context.read<AIRepository>(),
          ),
      child: BlocConsumer<ResumeAnalizerBloc, ResumeAnalizerState>(
        listener: (context, state) {
          final bloc = context.read<ResumeAnalizerBloc>();

          state.mapOrNull(
            loaded: (value) {
              final response = value.serverResponse;
              if (response != null && !response.result) {
                _showErrorDialog(context, response.message);
                bloc.add(ResetResponseEvent());
              }
              if (value.response != null && !value.scrolled) {
                bloc.add(ScrollEvent());
              }
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<ResumeAnalizerBloc>();

          return state.map(
            loaded: (value) {
              return SingleChildScrollView(
                controller: bloc.scrollController,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Analizador de Hojas de Vida',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sube tu hoja de vida y la oferta de trabajo para obtener un análisis detallado del perfil profesional',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          LucideIcons.briefcase,
                                          color: SchemaColors.secondary500,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Oferta de Trabajo',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ingresa la descripción de la oferta de trabajo para comparar.',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Descripción del puesto',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomInput(
                                      maxLines: 12,
                                      isPassword: false,
                                      validator:
                                          (text) => text.validateWith([
                                            FormValidator.notEmpty(),
                                          ]),
                                      onChanged:
                                          (text) =>
                                              bloc.add(GetOfferTextEvent(text)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // shape: ,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          LucideIcons.fileText,
                                          color: SchemaColors.secondary500,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Subir Hoja de Vida',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sube tu hoja de vida en formato PDF, DOCX o TXT para analizarla.',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    value.file == null
                                        ? DottedBorderbox(
                                          onFilePicked:
                                              (file) => bloc.add(
                                                ResumeAnalizerEvents.uploadFile(
                                                  file,
                                                ),
                                              ),
                                        )
                                        : Card(
                                          color: Colors.grey.shade50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: Icon(
                                              LucideIcons.file,
                                              color: SchemaColors.primary,
                                              size: 28,
                                            ),
                                            title: Text(value.file!.name),
                                            subtitle: Text(
                                              "${(value.file!.size / 1024).toStringAsFixed(2)} KB",
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                // Limpiar archivo
                                                bloc.add(
                                                  const ResumeAnalizerEvents.uploadFile(
                                                    null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child:
                            value.loading
                                ? LoadingState()
                                : CustomIconButton(
                                  disabled: value.file == null,
                                  message: 'Analizar Hoja de Vida',
                                  icon: LucideIcons.fileBarChart,
                                  onPressed: () {
                                    if (formKey.currentState!.validate() &&
                                        value.file != null) {
                                      bloc.add(LoadingEvent(true));
                                      bloc.add(AnalyzeEvent());
                                    } else {
                                      return;
                                    }
                                  },
                                ),
                      ),
                      SizedBox(height: 32),
                      value.response == null
                          ? Container()
                          : CVAnalysisCard(
                            key: bloc.cardKey,
                            analysis: value.response!,
                          ),
                    ],
                  ),
                ),
              );
            },
            failed:
                (value) => FailureState(failure: value.failure, onRetry: () {}),
          );
        },
      ),
    );
  }
}
