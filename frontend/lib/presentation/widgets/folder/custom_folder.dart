import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';

class CustomFolder extends StatelessWidget {
  final IconData icon;
  final String name;
  final String fileCount;
  final String size;
  const CustomFolder({
    super.key,
    required this.icon,
    required this.name,
    required this.fileCount,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.folder, size: 100, color: SchemaColors.warning),
        SizedBox(height: 5),
        Text(
          "Proyecto",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "8 archivos",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(width: 10),
            Text("2 MB", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
