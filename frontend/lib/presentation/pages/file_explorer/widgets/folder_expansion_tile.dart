import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class FolderExpansionTile extends StatelessWidget {
  final FolderModel folder;
  const FolderExpansionTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      leading: Icon(Icons.folder, color: SchemaColors.warning, size: 30),
      title: Text(folder.name),
      children: [
        ...folder.subFolders.map((sub) => FolderExpansionTile(folder: sub)),
        ...folder.files.map(
          (file) => ListTile(
            leading: Icon(Icons.insert_drive_file, color: SchemaColors.primary),
            title: Text(file.name),
            subtitle: Text(file.type),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text("${file.size} MB")],
            ),
          ),
        ),
      ],
    );
  }
}
