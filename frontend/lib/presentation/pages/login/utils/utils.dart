part of '../view/login_view.dart';

// Ejecuta método de loginBloc para autenticar usuario
void _submit(BuildContext context) async {
  final LoginBloc loginBloc = context.read<LoginBloc>();
  final Globalcubit globalBloc = context.read<Globalcubit>();
  final result = await loginBloc.authUser();
  // Verifica que el contexto siga siendo válido antes de interactuar con la UI
  if (context.mounted) {
    result.when(
      right: (response) {
        if (response.result == false) {
          _showAlertDialog(context, response.message);
          return;
        }
        final user = UserSessionModel.fromJson(response.data);
        globalBloc.setUser(user);
        response.result ? Navigator.pushReplacementNamed(context, '/home') : _showAlertDialog(context, response.message);
      },  
      left: (failure) => _showAlertDialog(context,'Credenciales incorrectas. Intente de nuevo.' ),
    );
  }
}

// Muestra un diálogo de error
Future<void> _showAlertDialog(BuildContext context, String message) async {
  return showDialog(
    context: context, 
    builder: (context) => ErrorDialog(message: message ),
  );
}
