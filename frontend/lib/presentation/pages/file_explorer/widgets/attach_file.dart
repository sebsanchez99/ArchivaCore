import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AttachFile extends StatelessWidget {
  final FileExplorerBloc bloc;

  const AttachFile({
    super.key, 
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Form(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: SchemaColors.neutral100,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Subir archivo",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: SchemaColors.textPrimary),
                ),
                const SizedBox(height: 5),
                Text(
                  'Selecciona el archivo que desees subir. Máximo 50MB por archivo.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: SchemaColors.textSecondary),
                ),
                const SizedBox(height: 20),
                BlocBuilder<FileExplorerBloc, FileExplorerState>(
                  builder: (context, state) {
                    return Center(
                      child: state.maybeMap(
                        loaded: (value) {
                          return value.file == null
                            ? InkWell(
                                onTap: () => pickFile(context, bloc),
                                child: DottedBorder(
                                  padding: const EdgeInsets.all(20),
                                  dashPattern: const [9],
                                  color: SchemaColors.border,
                                  strokeWidth: 1,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  child: Container(
                                    width: 355,
                                    height: 180,
                                    color: SchemaColors.background,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          color: SchemaColors.secondary,
                                          size: 40,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Haz clic para seleccionar un archivo',
                                          style: TextStyle(
                                            color: SchemaColors.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container( 
                              width: 355,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: SchemaColors.neutral100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: SchemaColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // 🔹 Icono
                                  const Icon(
                                    LucideIcons.fileText, 
                                    color: SchemaColors.primary700,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 15),
                                  // 🔹 Nombre y tamaño del archivo
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.file!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: SchemaColors.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis, 
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${(value.file!.size / 1024).toStringAsFixed(2)} KB",
                                          style: const TextStyle(
                                            color: SchemaColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 🔹 Botón de eliminar
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                    onPressed: () => context.read<FileExplorerBloc>().add(FileExplorerEvents.uploadFile(null)),
                                    tooltip: 'Eliminar archivo',
                                  ),
                                ],
                              ),
                            );
                        },
                        orElse: () => const SizedBox.shrink(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          actions: [
            CustomButton(
              message: 'Cancelar',
              onPressed: () {
                Navigator.pop(context);
                bloc.add(FileExplorerEvents.uploadFile(null));
              } 
            ),
            CustomButton(
              message: 'Subir archivo',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}