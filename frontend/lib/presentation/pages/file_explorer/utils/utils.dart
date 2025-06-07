part of '../view/file_explorer_view.dart';


Future<void> _showCreateDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CreateFolder(),
  );
}