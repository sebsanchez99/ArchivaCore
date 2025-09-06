import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/drop_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:frontend/presentation/widgets/folder/custom_folder.dart';
import 'package:dotted_border/dotted_border.dart';

class EditFolder extends StatelessWidget {
  const EditFolder({super.key});

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
            DropButton(),
            SizedBox(height: 2),
            Text('Nueva ruta: /ArchivaCore'),
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
                      onPressed: () {},
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
                    'Tamaño:',
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
