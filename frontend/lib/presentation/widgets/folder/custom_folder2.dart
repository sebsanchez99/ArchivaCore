import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomFolder2 extends StatelessWidget {
  final IconData leading;
  final String title;

  const CustomFolder2({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading, color: SchemaColors.warning), // color opcional
      title: Text(title),
    );
  }
}

class CustomFile2 extends StatelessWidget {
  final String title;

  const CustomFile2({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.file_copy,
        color: SchemaColors.secondary200,
      ),
      title: Text(title),
    );
  }
}
