part of '../view/adminitration_view.dart';

//Muestra el dialogo para editar un usuario
Future<void> _showEditDialog(BuildContext context) async {
  return showDialog(context: context, builder: (context) => EdituserWindow());
}

Future<void> _showCreateDialog(BuildContext context) async {
  final bloc = context.read<AdministrationBloc>();
  return showDialog(
    context: context,
    builder: (context) => CreateUserWindow(bloc: bloc),
  );
}

Future<void> _showResult(
  BuildContext context,
  ServerResponseModel response,
) async {
  return showDialog(
    context: context,
    builder:
        (context) =>
            response.result
                ? SuccessDialog (message: response.message)
                : ErrorDialog(message: response.message),
  );
}

//Ventana de confirmación que aparece cuando se elimina un usuario 
Future<void> _showInfoDialog(BuildContext context, String userID) async {
  final bloc = context.read<AdministrationBloc>();
  return showDialog(
    context: context,
    builder:
        (context) => InfoDialog(
          message: '¿Desea eliminar el usuario?',
          onPressed: () => bloc.add(DeleteUserEvent(userID: userID)),
        ),
  );
}
