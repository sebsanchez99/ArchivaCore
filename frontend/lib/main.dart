import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login/view/login_view.dart';
import 'package:frontend/providers/providers.dart';
import 'package:frontend/prueba.dart';
import 'package:provider/provider.dart';

void main() {
  //Asegura que Flutter esté completamente inicializado antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  // Configura los Providers que se usarán dentro de la aplicación
  runApp(MultiProvider(providers: appProviders, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArchivaCore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        '/': (context) => const LoginView(),
        '/prueba': (context) => const Prueba()
      }, 
    );
  }
}

