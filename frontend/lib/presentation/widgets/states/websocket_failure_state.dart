import 'package:flutter/material.dart';
import 'package:frontend/domain/failures/websocket_failure.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class WebSocketFailureState extends StatelessWidget {
  final WebSocketFailure? failure;

  const WebSocketFailureState({
    super.key,
    this.failure,
  });

@override
Widget build(BuildContext context) {
  final error = failure; 

  if (error == null) {
    // Estado predeterminado si no hay error
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingState(),
            SizedBox(height: 16),
            Text(
              'Conectando...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Datos de error si existe
  late IconData icon;
  late String title;
  late String message;
  late Color iconColor;

  error.maybeMap( 
    connection: (_) {
      title = 'Error de conexión';
      message = 'No se pudo establecer la conexión.';
      icon = Icons.wifi_off;
      iconColor = Colors.redAccent;
    },
    timeout: (_) {
      title = 'Tiempo agotado';
      message = 'El intento de conexión tardó demasiado.';
      icon = Icons.timer_off;
      iconColor = Colors.orange;
    },
    server: (_) {
      title = 'Fallo del servidor';
      message = 'Hubo un problema en el servidor.';
      icon = Icons.cloud_off;
      iconColor = Colors.purple;
    },
    local: (_) {
      title = 'Error local';
      message = 'Ocurrió un error inesperado.';
      icon = Icons.bug_report;
      iconColor = Colors.deepOrange;
    },
    orElse: () {
      title = 'Error desconocido';
      message = 'Se produjo un fallo inesperado.';
      icon = Icons.error_outline;
      iconColor = Colors.grey;
    },
  );

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 70,
                height: 70,
                child: LoadingState(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
