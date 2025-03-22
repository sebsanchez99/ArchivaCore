part of '../view/adminitration_view.dart';
//Muestra el dialogo para editar un usuario
Future<void> _showEditDialog(BuildContext context) async {
  return showDialog(
    context: context, 
    builder: (context) => EdituserWindow(),
  );
}

Future<void> _showCreateDialog(BuildContext context) async {
  final bloc = context.read<AdministrationBloc>();
  return showDialog(
    context: context, 
    builder: (context) => CreateUserWindow(bloc: bloc),
  );
}

Future<void> _showResult(BuildContext context, ServerResponseModel response) async {
  return showDialog(
    context: context, 
    builder: (context) => response.result ? ErrorDialog(message: 'éxito') : ErrorDialog(message: 'error') 
  );
}


