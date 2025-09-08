import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_picker_modal.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateFolder extends StatefulWidget {
  final List<FolderModel> path;
  const CreateFolder({super.key, required this.path});
  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedPath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createFolder() {
    final folderName = _nameController.text.trim();
    final route = selectedPath ?? "/";

    if (folderName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El nombre de la carpeta es obligatorio")),
      );
      return;
    }

    context.read<FileExplorerBloc>().add(
      FileExplorerEvents.createFolder(
        folderName: folderName,
        routefolder: route,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: SchemaColors.neutral100,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Title(
              color: SchemaColors.textPrimary,
              child: const Text(
                "Crear Nueva Carpeta",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 5),
            const Text('Organiza tus archivos creando una nueva carpeta.'),
            const SizedBox(height: 10),

            //  Nombre
            const Text(
              'Nombre de la carpeta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomInput(
              controller: _nameController,
              isPassword: false,
              hintText: "ej: ArchivaCore",
            ),
            const SizedBox(height: 20),

            // 🔹 Ubicación
            const Text(
              'Ubicación',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                side: const BorderSide(color: SchemaColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                final ruta = await showDialog<String>(
                  context: context,
                  builder:
                      (context) =>
                          LocationPickerModal(rootFolders: widget.path),
                );

                if (ruta != null) {
                  setState(() {
                    selectedPath = ruta;
                  });
                }
              },
              child: Text(
                selectedPath ?? "Seleccionar ubicación",
                style: const TextStyle(
                  fontSize: 14,
                  color: SchemaColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Vista previa
            const Text(
              'Vista previa',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 330,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: SchemaColors.background,
                ),
                child: DottedBorder(
                  dashPattern: const [9],
                  color: SchemaColors.border,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: Center(
                    child: CustomFolder(
                      onPressed: () {},
                      icon: Icons.folder,
                      name:
                          _nameController.text.isEmpty
                              ? 'Nueva Carpeta'
                              : _nameController.text,
                      fileCount: '—',
                      size: '—',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(message: 'Crear Carpeta', onPressed: _createFolder),
      ],
    );
  }
}
