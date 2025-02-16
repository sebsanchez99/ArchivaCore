part of '../view/login_view.dart';

// Ejecuta método de bloc para autenticar usuario
void _submit(BuildContext context) async {
  final LoginBloc bloc = context.read();
  final result = await bloc.authUser();
  // Verifica que el contexto siga siendo válido antes de interactuar con la UI
  if (context.mounted) {
    result.when(
      right: (_) => Navigator.pushReplacementNamed(context, '/prueba'), 
      left: (failure) => print(failure),
    );
  }
}
