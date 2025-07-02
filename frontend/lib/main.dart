import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/cubit/globalcubit.dart';
import 'package:frontend/presentation/pages/home_view.dart';
import 'package:frontend/presentation/pages/login/view/login_view.dart';
import 'package:frontend/presentation/global/providers/providers.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MultiProvider(
      providers: [
        ...appProviders,
        BlocProvider<Globalcubit>(
          create: (_) => Globalcubit(navigatorKey),
        ),
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'ArchivaCore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        // '/': (context) => const HomeView(),
        '/': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
      }, 
    );
  }
}

