part of '../view/settings_view.dart';


Future<void> _showResult(BuildContext context, ServerResponseModel response) async {
  return showDialog(
    context: context,
    builder: (context) => response.result ? SuccessDialog (message: response.message) : ErrorDialog(message: response.message),
  );
}

//Ventana de confirmación que aparece cuando se elimina un usuario 
Future<void> _showInfoDialog(BuildContext context) async {
  final bloc = context.read<SettingsBloc>();
  return showDialog(
    context: context,
    builder:(context) => InfoDialog(
      message: '¿Desea cambiar la contraseña?',
      onPressed: () => bloc.add(ChangePasswordEvent())
    ),
  );
}
