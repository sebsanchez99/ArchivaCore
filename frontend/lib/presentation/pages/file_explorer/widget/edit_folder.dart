import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:dotted_border/dotted_border.dart';

class EditFolder extends StatefulWidget {
  EditFolder({super.key});

  @override
  State<EditFolder> createState() => _EditFolderState();
}

class _EditFolderState extends State<EditFolder> {
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
                "Editar Carpeta",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 5),
            Text('Modifica los detalles de tu carpeta.'),
            SizedBox(height: 20),
            Text(
              'Nombre de la carpeta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomInput(isPassword: false, hintText: "ArchivaCore"),
            SizedBox(height: 20),
            Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'ArchivaCore',
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
                    width: 350,
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
            SizedBox(height: 5),
            Text('Nueva ruta: /ArchivaCore'),
            SizedBox(height: 20),
            Divider(color: SchemaColors.border),
            SizedBox(height: 20),
            Text(
              'Vista previa de cambios',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 330,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: SchemaColors.background,
                ),
                child: DottedBorder(
                  dashPattern: [9],
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
            SizedBox(height: 5),
            Text('Si hay cambios pendientes'),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              width: 330,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: SchemaColors.border, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: SchemaColors.background,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Creada:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Ultima Modificacion:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Contenido:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
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
          message: 'Editar Carpeta',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
