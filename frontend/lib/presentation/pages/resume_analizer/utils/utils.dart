part of '../view/resume_analizer_view.dart';

Future<void> _showErrorDialog(BuildContext context, String message) async {
  return showDialog(
    context: context, 
    builder: (context) => ErrorDialog(message: message)
  );
}