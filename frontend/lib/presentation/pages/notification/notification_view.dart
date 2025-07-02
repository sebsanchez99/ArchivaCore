import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/notification/widget/custom_notification.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button2.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notificaciones",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton2(onPressed: () {}, message: 'Todos'),
                SizedBox(width: 20),
                CustomButton2(onPressed: () {}, message: 'No leidas'),
              ],
            ),

            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CustomNotification(
                    icon: Icons.file_copy,
                    color: SchemaColors.secondary300,
                    titulo: 'Nuevos archivos subidos',
                    detalle: 'Se han subido nuevos archivos al sistema',
                    tiempo: 'Hace 2 minutos',
                  ),
                  CustomNotification(
                    icon: Icons.folder,
                    color: SchemaColors.warning,
                    titulo: 'Se ha creado una nueva carpeta',
                    detalle: 'Se ha creado una carpeta llamada "Proyectos"',
                    tiempo: 'Hace 15 minutos',
                  ),
                  CustomNotification(
                    icon: Icons.file_copy,
                    color: SchemaColors.secondary300,
                    titulo: 'Nuevo mensaje recibido',
                    detalle: 'Se han subido nuevos archivos al sistema',
                    tiempo: 'Hace 2 minutos',
                  ),
                  CustomNotification(
                    icon: Icons.folder,
                    color: SchemaColors.warning,
                    titulo: 'Se ha creado una nueva carpeta',
                    detalle: 'Se ha creado una carpeta llamada "Proyectos',
                    tiempo: 'Hace 15 minutos',
                  ),
                  CustomNotification(
                    icon: Icons.file_copy,
                    color: SchemaColors.secondary300,
                    titulo: 'Nuevo mensaje recibido',
                    detalle: 'Se han subido nuevos archivos al sistema',
                    tiempo: 'Hace 2 minutos',
                  ),
                  CustomNotification(
                    icon: Icons.folder,
                    color: SchemaColors.warning,
                    titulo: 'Se ha creado una nueva carpeta',
                    detalle: 'Se ha creado una carpeta llamada "Proyectos',
                    tiempo: 'Hace 15 minutos',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
