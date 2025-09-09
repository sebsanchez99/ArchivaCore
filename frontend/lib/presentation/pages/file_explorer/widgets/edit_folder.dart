// edit_folder_dialog.dart

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/states/file_explorer_state.dart';
import 'package:frontend/presentation/pages/file_explorer/utils/utils.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_button.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/location_picker_modal.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/utils/validator/form_validator.dart';
import 'package:frontend/utils/validator/form_validator_extension.dart';

class EditFolder extends StatefulWidget {
 final FileExplorerBloc bloc;
 final FolderModel folder;

 const EditFolder({
  super.key,
  required this.bloc,
  required this.folder,
 });

 @override
 EditFolderState createState() => EditFolderState();
}

class EditFolderState extends State<EditFolder> {
 late final TextEditingController _nameController;
 String? selectedPath;
 final _formKey = GlobalKey<FormState>();

 @override
 void initState() {
  super.initState();
  _nameController = TextEditingController(text: widget.folder.name);
  selectedPath = widget.folder.path; 
 }

 @override
 void dispose() {
  _nameController.dispose();
  super.dispose();
 }

 String _calculateFolderSize() {
  final totalSizeMB = widget.folder.files.fold<double>(0.0, (sum, f) => sum + (double.tryParse(f.size) ?? 0.0));
  return '${totalSizeMB.toStringAsFixed(2)} MB';
 }

 int _calculateTotalItems() {
  return widget.folder.files.length + widget.folder.subFolders.length;
 }

 @override
 Widget build(BuildContext context) {
  return BlocProvider.value(
   value: widget.bloc,
   child: Form(
    key: _formKey,
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
          "Editar Carpeta",
          style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 22,
           color: SchemaColors.textPrimary,
          ),
         ),
         const SizedBox(height: 8),
         const Text('Modifica los detalles de tu carpeta.'),
         const SizedBox(height: 15),
         Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              _buildSectionTitle('Nombre de la carpeta'),
              const SizedBox(height: 10),
              CustomInput(
               isPassword: false,
               hintText: widget.folder.name,
               controller: _nameController,
               validator: (value) =>
                 value.validateWith([FormValidator.notEmpty()]),
               onChanged: (text) {
                setState(() {});
               },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Ubicación actual'),
              const SizedBox(height: 10),
              BlocBuilder<FileExplorerBloc, FileExplorerState>(
               builder: (context, state) {
                return state.maybeMap(
                 orElse: () => const SizedBox.shrink(),
                 loaded: (value) => SizedBox(
                  width: double.infinity,
                  child: LocationButton(
                   text: 'Seleccionar ubicación',
                   selectedPath: selectedPath,
                   onPressed: () async {
                    final ruta = await showDialog<String>(
                     context: context,
                     builder: (context) => LocationPickerModal(rootFolders: value.folders),
                    );
                    if (ruta != null) {
                     setState(() {
                      selectedPath = ruta;
                     });
                    }
                   },
                  ),
                 ),
                );
               },
              ),
             ],
            ),
           ),
           const SizedBox(width: 30),
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              _buildSectionTitle('Vista previa de cambios'),
              const SizedBox(height: 10),
              _buildPreviewSection(),
              const SizedBox(height: 20),
             ],
            ),
           ),
          ],
         ),
         _buildSectionTitle('Propiedades'),
         const SizedBox(height: 10),
         _buildPropertiesSection(),
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
       onPressed: () async {
        if (selectedPath == null) {
          await showErrorDialog(context, 'La ubicación de la carpeta es obligatoria');
          return;
        }   
             
        if (_formKey.currentState!.validate()) {
        }
       },
      ),
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

 Widget _buildPreviewSection() {
  return DottedBorder(
   dashPattern: const [9],
   color: SchemaColors.border,
   strokeWidth: 1,
   borderType: BorderType.RRect,
   radius: const Radius.circular(10),
   child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(10),
     color: SchemaColors.background,
    ),
    child: CustomFolder(
     onPressed: () {},
     icon: Icons.folder,
     name: _nameController.text.isEmpty
       ? 'Nombre no definido'
       : _nameController.text,
     fileCount:
       '${widget.folder.files.length + widget.folder.subFolders.length} Elementos',
     size: _calculateFolderSize(),
    ),
   ),
  );
 }

 Widget _buildPropertiesSection() {
  return Container(
   width: double.infinity,
   padding: const EdgeInsets.all(15),
   decoration: BoxDecoration(
    border: Border.all(color: SchemaColors.border, width: 1),
    borderRadius: BorderRadius.circular(10),
    color: SchemaColors.background,
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     _buildDetailRow(label: 'Número de elementos', value: _calculateTotalItems().toString()),
     _buildDetailRow(label: 'Tamaño', value: _calculateFolderSize()),
     _buildDetailRow(label: 'Ruta actual', value: widget.folder.path),
    ],
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
       style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
       ),
      ),
     ),
     Expanded(
      child: Text(
       value,
       style: const TextStyle(
        fontSize: 12,
        color: SchemaColors.textSecondary,
       ),
      ),
     ),
    ],
   ),
  );
 }
}