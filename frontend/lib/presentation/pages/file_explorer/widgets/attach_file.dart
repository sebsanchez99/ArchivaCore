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
  final TextEditingController _nameController = TextEditingController();
  String? selectedPath;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updatePreview);
    _nameController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
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
                                      _getFileIcon(value.file!.extension!),
                                      color: _getFileColor(value.file!.extension!),
                                      size: 28,
                                    ),
                                    const SizedBox(width: 15),
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
                                      onPressed: () => context.read<FileExplorerBloc>().add(FileExplorerEvents.uploadFile(null)),
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
                                      builder: (context) => LocationPickerModal(rootFolders: value.content.folders),
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
                          );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          CustomButton(
            message: 'Cancelar',
            onPressed: () {
              Navigator.pop(context);
              widget.bloc.add(FileExplorerEvents.uploadFile(null));
            } 
          ),
          CustomButton(
            message: 'Subir archivo',
            onPressed: () async {
              if (selectedPath == null) {
                await showErrorDialog(context, 'La ubicación de la carpeta es obligatoria');
                return;
              }
            },
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String type) {
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

  Color _getFileColor(String type) {
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