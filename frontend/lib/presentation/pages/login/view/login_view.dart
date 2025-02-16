import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/auth_repository.dart';
import 'package:frontend/presentation/pages/login/bloc/login_bloc.dart';
import 'package:frontend/presentation/pages/login/bloc/login_events.dart';
import 'package:frontend/presentation/pages/login/bloc/login_state.dart';

part '../utils/utils.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginState(), authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF3FA),
        body: Center(
          child: Container(
            width: 700,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A5A98),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "ArchivaCore",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous.blocking != current.blocking,
                      builder:
                          (context, state) => AbsorbPointer(
                            absorbing: state.blocking,
                            child: Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "Usuario",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onChanged: (text) => context.read<LoginBloc>().add(LoginEvents.usernameChanged(text.trim())),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Contraseña",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                                    onSubmitted: (_) => _submit(context),
                                    onChanged: (text) => context.read<LoginBloc>().add(LoginEvents.passwordChanged(text.trim())),
                                  ),
                                  const SizedBox(height: 15),
                                  state.blocking
                                      ? const Center(child: CircularProgressIndicator())
                                      : Builder(
                                        builder: (ctx) {
                                          return SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                      255,
                                                      253,
                                                      253,
                                                      255,
                                                    ),
                                                foregroundColor:
                                                    const Color.fromARGB(
                                                      255,
                                                      10,
                                                      6,
                                                      6,
                                                    ),
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                              ),
                                              onPressed: () => _submit(context),
                                              child: const Text("Entrar"),
                                            ),
                                          );
                                        },
                                      ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
