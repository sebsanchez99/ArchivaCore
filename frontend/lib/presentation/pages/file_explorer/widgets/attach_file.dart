import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_button.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_picker_modal.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

class AttachFile extends StatefulWidget {
  final FileExplorerBloc bloc;

  const AttachFile({
    super.key, 
    required this.bloc,
  });

  @override
  State<AttachFile> createState() => _AttachFileState();
}

class _AttachFileState extends State<AttachFile> {
  String? selectedPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<FileExplorerBloc, FileExplorerState>(
        builder: (context, state) {
          final loadedState = state.mapOrNull(loaded: (value) => value);
          final isBusy = loadedState?.isBusy ?? false;
          final file = loadedState?.file;

          return AbsorbPointer(
            absorbing: isBusy,
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
                    Center(
                      child: file == null
                          ? InkWell(
                              onTap: () => pickFile(context, widget.bloc),
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
                          : Column(
                              children: [
                                Container( 
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
                                      Icon(
                                        // Aquí estaba el error
                                        _getFileIcon(file.extension),
                                        color: _getFileColor(file.extension),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              file.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: SchemaColors.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis, 
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${(file.size / 1024).toStringAsFixed(2)} KB",
                                              style: const TextStyle(
                                                color: SchemaColors.textSecondary,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'En: ${selectedPath ?? "—"}',
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
                                        onPressed: () => context.read<FileExplorerBloc>().add(const FileExplorerEvents.uploadFile(null)),
                                        tooltip: 'Eliminar archivo',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  width: double.infinity,
                                  child: LocationButton(
                                    text: 'Seleccionar ubicación',
                                    selectedPath: selectedPath,
                                    onPressed: () async {
                                      final ruta = await showDialog<String>(
                                        context: context,
                                        builder: (context) => LocationPickerModal(rootFolders: loadedState!.content.folders),
                                      );
                                  
                                      if (ruta != null) {
                                        setState(() {
                                          selectedPath = ruta;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (isBusy)
                  const Center(child: CircularProgressIndicator(color: SchemaColors.primary))
                else ...[
                  CustomButton(
                    message: 'Cancelar',
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<FileExplorerBloc>().add(const FileExplorerEvents.uploadFile(null));
                    }, 
                  ),
                  CustomButton(
                    message: 'Subir archivo',
                    onPressed: () async {
                      if (file == null) {
                        await showErrorDialog(context, 'Debes seleccionar un archivo primero');
                        return;
                      }

                      if (selectedPath == null) {
                        await showErrorDialog(context, 'La ubicación de la carpeta es obligatoria');
                        return;
                      }
                      
                      context.read<FileExplorerBloc>().add(FileExplorerEvents.createFile(folderRoute: selectedPath!));
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getFileIcon(String? type) {
    if (type == null) {
      return Icons.insert_drive_file;
    }
    switch (type.toLowerCase()) {
      case "pdf":
        return Icons.picture_as_pdf;
      case "doc":
      case "docx":
        return Icons.description;
      case "jpg":
      case "png":
      case "jpeg":
        return Icons.image;
      case "mp4":
      case "avi":
        return Icons.movie;
      case "mp3":
      case "wav":
        return Icons.music_note;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String? type) {
    if (type == null) {
      return SchemaColors.primary;
    }
    switch (type.toLowerCase()) {
      case "pdf":
        return Colors.red;
      case "doc":
      case "docx":
        return Colors.blue;
      case "jpg":
      case "png":
      case "jpeg":
        return Colors.orange;
      case "mp4":
      case "avi":
        return Colors.purple;
      case "mp3":
      case "wav":
        return Colors.green;
      default:
        return SchemaColors.primary;
    }
  }
}