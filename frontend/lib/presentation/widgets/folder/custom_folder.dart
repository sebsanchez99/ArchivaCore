import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomFolder extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String name;
  final String fileCount;
  final String size;

  const CustomFolder({
    super.key,
    required this.icon,
    required this.name,
    required this.fileCount,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 40, color: SchemaColors.warning),
        ),
        const SizedBox(height: 1),
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fileCount,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Text(
              size,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
