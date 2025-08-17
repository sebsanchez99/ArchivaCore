import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/drop_button.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

class AttachFile extends StatelessWidget {
  const AttachFile({super.key});

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
                "Adjuntar Archivo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Selecciona o arrastra los archivos que desees subir. Maximo 10MB por archivo.',
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 355,
                height: 180,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: SchemaColors.textSecondary,
                          size: 40,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'Arrastra y suelta archivos aquí o',
                          style: TextStyle(
                            color: SchemaColors.textPrimary,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'haz clic para seleccionar archivos',
                          style: TextStyle(
                            color: SchemaColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {},
                          child: Text('Seleccionar archivos'),
                          style: TextButton.styleFrom(
                            foregroundColor: SchemaColors.textPrimary,
                            textStyle: TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 17,
                            ),
                            side: BorderSide(
                              color: SchemaColors.border,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(child: DropButton()),
          ],
        ),
      ),
      actions: [
        CustomButton(
          message: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          message: 'Subir archivo',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
