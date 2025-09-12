import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_picker_modal.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart'; // Import the state
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';

class CreateFolder extends StatefulWidget {
  final List<FolderModel> path;
  const CreateFolder({super.key, required this.path});
  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedPath;
  final _formKey = GlobalKey<FormState>();

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
    return BlocBuilder<FileExplorerBloc, FileExplorerState>(
      builder: (context, state) {

        final isBusy = state.mapOrNull(loaded: (value) => value.isBusy) ?? false;
        
        return Form(
          key: _formKey,
          child: AlertDialog(
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
                  
                  // 🔹 Nombre
                  const Text(
                    'Nombre de la carpeta',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: _nameController,
                    isPassword: false,
                    hintText: "ej: ArchivaCore",
                    validator: (value) => value.validateWith([FormValidator.folderFileName()])
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Ubicación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: LocationButton(
                      text: 'Seleccionar ubicación',
                      selectedPath: selectedPath,
                      onPressed: () async {
                        final ruta = await showDialog<String>(
                          context: context,
                          builder: (context) => LocationPickerModal(rootFolders: widget.path),
                        );
                      
                        if (ruta != null) {
                          setState(() {
                            selectedPath = ruta;
                          });
                        }
                      },
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
                            name: _nameController.text.isEmpty
                                ? 'Nueva Carpeta'
                                : _nameController.text,
                            fileCount: selectedPath != null ? 'En: ${selectedPath!}' : '—',
                            size: '',
                          ),
                        ),
                      ),
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
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton(
                  message: 'Crear Carpeta', 
                  onPressed: () async {
                    if (selectedPath == null) {
                      await showErrorDialog(context, 'La ubicación de la carpeta es obligatoria');
                      return;
                    }
                    
                    if (_formKey.currentState!.validate()) {
                      context.read<FileExplorerBloc>().add(
                        FileExplorerEvents.createFolder(folderName: _nameController.text.trim(), routefolder: selectedPath!),
                      );
                    }
                  }
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}