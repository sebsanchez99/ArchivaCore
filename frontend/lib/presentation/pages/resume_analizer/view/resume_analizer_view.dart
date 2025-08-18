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
      create: (context) => ResumeAnalizerBloc(ResumeAnalizerState.loaded(), aiRepository: context.read<AIRepository>()),
      child: BlocConsumer<ResumeAnalizerBloc, ResumeAnalizerState>(
        listener: (context, state) {
          state.mapOrNull(
            loaded: (value) {
              final response = value.serverResponse;
              if (response != null && !response.result) {
                _showErrorDialog(context, response.message);
              }
            },
          );
        },
        builder: (context, state) {
          final bloc = context.read<ResumeAnalizerBloc>();

          return state.map(
            loaded: (value) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Analizador de Hojas de Vida',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sube tu hoja de vida y la oferta de trabajo para obtener un análisis detallado del perfil profesional',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
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
                                side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Oferta de Trabajo',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ingresa la descripción de la oferta de trabajo para comparar',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Descripción del puesto',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomInput(
                                      maxLines: 12,
                                      hintText: 'Pega aquí la oferta completa de trabajo...',
                                      isPassword: false,
                                      validator: (text) => text.validateWith([FormValidator.notEmpty()]),
                                      onChanged: (text) => bloc.add(GetOfferTextEvent(text)),
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
                                side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // shape: ,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Subir Hoja de Vida',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sube tu hoja de vida en formato PDF, DOCX o TXT para analizarla',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 16),
                                    value.file == null 
                                    ? DottedBorderbox(
                                      onFilePicked: (file) => bloc.add(ResumeAnalizerEvents.uploadFile(file)),
                                    )
                                    :  Card(
                                      color: Colors.grey.shade50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () {
                                            // Limpiar archivo
                                            bloc.add(const ResumeAnalizerEvents.uploadFile(null));
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
                        child: value.loading 
                        ? LoadingState()
                        :CustomIconButton(
                          disabled: value.file == null,
                          message: 'Analizar Hoja de Vida', 
                          icon: LucideIcons.fileBarChart, 
                          onPressed: () {
                            if (formKey.currentState!.validate() && value.file != null) {
                              bloc.add(LoadingEvent(true));
                              bloc.add(AnalyzeEvent());
                            } else {
                              return;
                            }
                          }
                        ),
                      ),
                      SizedBox(height: 32),
                      value.response == null 
                      ? Container()
                      : CVAnalysisCard(analysis: value.response!)

                      // Card(
                      //   color: Colors.white, 
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //     side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                      //   ),
                      //   elevation: 0,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(24),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Icon(Icons.check_circle, color: Colors.green),
                      //             const SizedBox(width: 8),
                      //             Text(
                      //               'Análisis Completo',
                      //               style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade800, fontSize: 25),
                      //             )
                      //           ],
                      //         ),
                      //         const SizedBox(height: 4),
                      //         const Text('Resultados del análisis de la hoja de vida'),
                      //         const SizedBox(height: 16),
                      //         const Text(
                      //           'Resumen del perfil',
                      //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      //         ),
                      //         const SizedBox(height: 4),
                      //         const Text(
                      //           'Profesional con experiencia en desarrollo de software y habilidades en React, Node.js y diseño de interfaces. Demuestra capacidad para trabajar en equipo y liderar proyectos.',
                      //           style: TextStyle(fontSize: 13),
                              
                      //         ),
                      //         const SizedBox(height: 24),
                      //         const Text(
                      //           'Resumen de compatibilidad',
                      //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      //         ),
                      //         const SizedBox(height: 4),
                      //         const Text(
                      //           'Tu perfil muestra una buena compatibilidad con la oferta de trabajo. Tienes experiencia relevante en desarrollo de software y la mayoría de las habilidades técnicas requeridas. Se recomienda destacar más tu experiencia en proyectos similares.',
                      //           style: TextStyle(fontSize: 13),
                      //         ),
                      //         const SizedBox(height: 24),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             StatCard(value: '87%', label: 'Compatibilidad', subtitle: 'con el perfil buscado'),
                      //             StatCard(value: '75%', label: 'Experiencia', subtitle: 'años en el sector'),
                      //             StatCard(value: '90%', label: 'Habilidades', subtitle: 'habilidades relevantes'),
                      //           ],
                      //         ),
                      //         const Divider(height: 32, thickness: 0.5, color: SchemaColors.primary),
                      //         Text(
                      //           'Habilidades destacadas',
                      //           style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      //         ),
                      //         const SizedBox(height: 12),
                      //         Wrap(
                      //           spacing: 8,
                      //           runSpacing: 8,
                      //           children: const [
                      //             SkillChip(label: 'React.js', color: Colors.green),
                      //             SkillChip(label: 'Node.js', color: Colors.blue),
                      //             SkillChip(label: 'Diseño UI/UX', color: Colors.purple),
                      //             SkillChip(label: 'TypeScript', color: Colors.orange),
                      //             SkillChip(label: 'Git', color: Colors.red),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 20),
                      //         Text(
                      //           'Áreas de mejora',
                      //           style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                      //         ),
                      //         const SizedBox(height: 12),
                      //         ImprovementItem(
                      //           icon: LucideIcons.alertCircle, 
                      //           title: 'Experiencia en liderazgo', 
                      //           message: 'Se recomienda adquirir experiencia en liderazgo de equipos para mejorar la compatibilidad con el perfil buscado.'
                      //         ),
                      //         const SizedBox(height: 12),
                      //         ImprovementItem(
                      //           icon: LucideIcons.alertCircle, 
                      //           title: 'Certificaciones técnicas', 
                      //           message: 'Considerar obtener certificaciones adicionales en tecnologías emergentes.'
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            },
            failed: (value) => FailureState(
              failure: value.failure, 
              onRetry: (){}
            ),
          );
        }
      ),
    );
  }
}