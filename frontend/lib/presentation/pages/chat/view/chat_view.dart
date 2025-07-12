import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/chat_repository.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_bloc.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_state.dart';
import 'package:frontend/presentation/pages/chat/widgets/chat_connected_view.dart';
import 'package:frontend/presentation/pages/chat/widgets/chat_initial_view.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/states/websocket_failure_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => ChatBloc(
        ChatState.loaded(), // puedes ajustar para manejar "cargando"
        chatRepository: context.read<ChatRepository>(),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: SchemaColors.secondary100),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
              final statusChip = state.maybeMap(
                loaded: (loaded) {
                  return loaded.connectionStatus.when(
                    connected: () => Chip(
                      side: BorderSide(style: BorderStyle.none),
                      label: const Text("Conectado", style: TextStyle(fontSize: 12)),
                      backgroundColor: SchemaColors.success,
                      labelStyle: const TextStyle(color: Colors.white),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    connecting: (_) => Chip(
                      side: BorderSide(style: BorderStyle.none),
                      label: const Text("Conectando...", style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.orangeAccent,
                      labelStyle: const TextStyle(color: Colors.white),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    disconnected: () => Chip(
                      side: BorderSide(style: BorderStyle.none),
                      label: const Text("Desconectado", style: TextStyle(fontSize: 12)),
                      backgroundColor: SchemaColors.error,
                      labelStyle: const TextStyle(color: Colors.white),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                  );
                },
                orElse: () => const Chip(label: Text("Estado desconocido")),
              );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(LucideIcons.messageCircle),
                            SizedBox(width: 8),
                            Text("Chat en vivo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        statusChip,
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tiempo de respuesta estimado: 3 minutos",
                      style: TextStyle(fontSize: 13, color: SchemaColors.textSecondary),
                    ),
                  ],
                );
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox.expand( 
                    child: state.map(
                      loaded: (value) => value.connectionStatus.map(
                        disconnected: (_) => ChatInitialView(),
                        connected:(_) => ChatConnectedView(),
                        connecting: (value) => WebSocketFailureState(failure: value.failure)
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
