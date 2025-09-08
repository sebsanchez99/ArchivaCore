import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/drop_button.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';
import 'package:intl/intl.dart'; // Mantén este import si el otro desarrollador lo necesita

class EditFile extends StatefulWidget {
  final FileModel file;
  final FileExplorerBloc bloc;

  const EditFile({
    super.key,
    required this.file,
    required this.bloc,
  });

  @override
  EditFileState createState() => EditFileState();
}

class EditFileState extends State<EditFile> {
  late final TextEditingController _nameController;
  late String _currentFolderPath;
  String? _selectedNewPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.file.name);
    _currentFolderPath = widget.file.path.contains('/')
        ? widget.file.path.substring(0, widget.file.path.lastIndexOf('/'))
        : '';
    _selectedNewPath = _currentFolderPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: SchemaColors.neutral100,
        content: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Editar Archivo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: SchemaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Modifica el nombre y la ubicación de tu archivo.'),
                const SizedBox(height: 15),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna izquierda para los campos de entrada
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Nombre del archivo'),
                          const SizedBox(height: 10),
                          CustomInput(
                            isPassword: false,
                            hintText: widget.file.name,
                            controller: _nameController,
                            validator: (value) => value.validateWith([FormValidator.notEmpty()]),
                            onChanged: (text) {
                              setState(() {}); 
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildSectionTitle('Ubicación'),
                          const SizedBox(height: 10),
                          _buildLocationDropdown(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Columna derecha para la vista previa
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Vista previa de cambios'),
                          const SizedBox(height: 10),
                          _buildPreviewSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          CustomButton(
            message: 'Cancelar',
            onPressed: () => Navigator.pop(context),
          ),
          CustomIconButton(
            message: 'Guardar cambios',
            icon: Icons.save,
            backgroundColor: SchemaColors.primary,
            iconColor: Colors.white,
            onPressed:() async {
              if (formKey.currentState!.validate()) {
                // widget.bloc.add();
              } else {
                return;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return widget.bloc.state.maybeMap(
      loaded: (value) {
        final List<String> availablePaths = List.from(value.paths);
        
        if (!availablePaths.contains(_currentFolderPath)) {
          availablePaths.insert(0, _currentFolderPath);
        }

        return DropButton(
          items: availablePaths,
          hint: 'Seleccionar ubicación',
          selectedValue: _selectedNewPath,
          onChanged: (newPath) {
            setState(() {
              _selectedNewPath = newPath;
            });
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  // Diseño de vista previa mejorado
  Widget _buildPreviewSection() {
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.file.date));
    return DottedBorder(
      dashPattern: const [9],
      color: SchemaColors.border,
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: Container(
        width: double.infinity, // Ocupa todo el espacio de la columna
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: SchemaColors.background,
        ),
        child: Column(
          children: [
            Icon(
              _getFileIcon(widget.file.type).icon,
              size: 50,
              color: _getFileIcon(widget.file.type).color,
            ),
            const SizedBox(height: 10),
            Text(
              _nameController.text.isEmpty ? 'Nombre no definido' : _nameController.text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              'Ruta: ${widget.file.path}',
              style: const TextStyle(fontSize: 14, color: SchemaColors.textSecondary),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            // Detalles del archivo
            _buildDetailRow(label: 'Tipo', value: widget.file.type.toUpperCase()),
            _buildDetailRow(label: 'Tamaño', value: '${widget.file.size} KB'),
            _buildDetailRow(label: 'Última modificación', value: formattedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: SchemaColors.primary700,
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: SchemaColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Icon _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case "pdf":
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case "doc":
      case "docx":
        return const Icon(Icons.description, color: Colors.blue);
      case "jpg":
      case "png":
      case "jpeg":
        return const Icon(Icons.image, color: Colors.orange);
      case "mp4":
      case "avi":
        return const Icon(Icons.movie, color: Colors.purple);
      case "mp3":
      case "wav":
        return const Icon(Icons.music_note, color: Colors.green);
      default:
        return const Icon(Icons.insert_drive_file, color: SchemaColors.primary);
    }
  }
}