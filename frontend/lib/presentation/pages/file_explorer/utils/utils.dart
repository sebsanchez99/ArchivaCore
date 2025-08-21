import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/attach_file.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/create_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/edit_folder.dart';

Future<void> showCreateFolderDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CreateFolder(),
  );
}
Future<void> showEditFolderDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EditFolder(),
  );
}
Future<void> showAttachFolderDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AttachFile(),
  );
}