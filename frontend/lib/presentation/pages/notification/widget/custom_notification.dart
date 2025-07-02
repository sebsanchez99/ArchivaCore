import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomNotification extends StatelessWidget {
  final color;
  final String titulo;
  final String detalle;
  final String tiempo;
  final IconData icon;
  const CustomNotification({
    super.key,
    this.color,
    required this.titulo,
    required this.detalle,
    required this.tiempo,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: SchemaColors.neutral700,
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.chevron_right,
                  size: 25,
                  color: SchemaColors.neutral900,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detalle),
            const SizedBox(height: 4),
            Text(
              tiempo,
              style: const TextStyle(
                fontSize: 12,
                color: SchemaColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
