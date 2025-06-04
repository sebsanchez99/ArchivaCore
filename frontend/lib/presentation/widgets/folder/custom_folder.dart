import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

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
        Icon(icon, size: 65, color: SchemaColors.warning),
        SizedBox(height: 1),
        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fileCount, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(width: 1),
            Text(size, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
