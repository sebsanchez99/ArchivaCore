import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder2.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateFolder extends StatefulWidget {
  CreateFolder({super.key});

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'B_Item4',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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
              child: Text(
                "Crear Nueva Carpeta",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nombre de la carpeta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomInput(isPassword: false, hintText: "ej: ArchivaCore"),
            SizedBox(height: 20),
            Text(
              'Descripción (Opcional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomInput(
              isPassword: false,
              hintText: "Describe el contenido o propocito de esta carpeta...",
            ),
            SizedBox(height: 20),
            Divider(color: SchemaColors.border),
            SizedBox(height: 20),
            Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Seleccionar ubicación',
                    style: TextStyle(
                      fontSize: 14,
                      color: SchemaColors.textPrimary,
                    ),
                  ),
                  items:
                      items
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 330,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.fromBorderSide(
                        BorderSide(color: SchemaColors.border, width: 1),
                      ),
                    ),
                  ),
                  dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                  menuItemStyleData: const MenuItemStyleData(height: 40),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Buscar ubicación...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().contains(searchValue);
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: SchemaColors.border),
            SizedBox(height: 20),
            Text('Vista previa', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: SchemaColors.neutral700,
                ),
                child: DottedBorder(
                  color: SchemaColors.border,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  child: Center(
                    child: CustomFolder(
                      icon: Icons.folder,
                      name: 'ArchivaCore',
                      fileCount: '9 Archivos',
                      size: '1.2 GB',
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
        CustomButton(
          message: 'Crear Carpeta',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
