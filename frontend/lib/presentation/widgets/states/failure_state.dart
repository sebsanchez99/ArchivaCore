import 'package:flutter/material.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';

// Widget que se encarga de mostrar estado de error según el fallo emitido
class FailureState extends StatelessWidget {
  final HttpRequestFailure failure;
  final VoidCallback onRetry;
  const FailureState({
    super.key, 
    required this.failure, 
    required this.onRetry
  });

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late String title;
    late String message;
    late Color iconColor;

    // Asigna valores de variables según error
    failure.when(
      network: () {
        title = 'Sin conexión';
        message = 'No se puede conectar a internet.';
        icon = Icons.wifi_off;
        iconColor = Colors.orangeAccent;
      }, 
      notFound: () {
        title = 'No encontrado';
        message = 'El recurso solicitado no existe.';
        icon = Icons.search_off;
        iconColor = Colors.blueGrey;
      }, 
      server: () {
        title = 'Error del servidor';
        message = 'Ocurrió un problema en el servidor.';
        icon = Icons.cloud_off;
        iconColor = Colors.purpleAccent;
      }, 
      unauthorized: () {
        title = 'No autorizado';
        message = 'No tienes permisos para acceder.';
        icon = Icons.lock_clock_outlined;
        iconColor = Colors.teal;
      }, 
      badRequest: () {
        title = 'Solicitud incorrecta';
        message = 'Hubo un problema con tu solicitud.';
        icon = Icons.error_outline;
        iconColor = Colors.amber;
      }, 
      local: () {
        title = 'Error local';
        message = 'Error interno en la aplicación.';
        icon = Icons.bug_report;
        iconColor = Colors.deepOrangeAccent;
      }, 
      expired: () {
        title = 'Sesión expirada';
        message = 'Tu sesión ha caducado. Vuelve a iniciar sesion.';
        icon = Icons.access_time_outlined;
        iconColor = Colors.redAccent;
      }
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: iconColor),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            CustomButton(message: 'Reintentar', onPressed: onRetry)
          ],
        ),
      ),
    );
  }
}