import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/administration/widgets/edit_user_window.dart';

//Muestra el dialogo para editar un usuario
Future<void> showEditDialog(BuildContext context) async {
  return showDialog(
    context: context, 
    builder: (context) => EdituserWindow(),
  );
}
