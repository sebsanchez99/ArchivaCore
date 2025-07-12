import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/global/cubit/globalcubit.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_bloc.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_events.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_state.dart';
import 'package:frontend/presentation/pages/chat/utils/utils.dart';
import 'package:frontend/presentation/pages/chat/widgets/system_text_bubble.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatConnectedView extends StatelessWidget {
  const ChatConnectedView({super.key});

  @override
  Widget build(BuildContext context) {
    final messageController = context.watch<ChatBloc>().messageController;
    final scrollController = context.watch<ChatBloc>().scrollController;

    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) => current.mapOrNull(loaded: (_) => true) ?? false,
      listener: (context, state) => scrollToBottom(scrollController),
      builder: (context, state) {
        return state.map(
          loaded: (loadedState) {
            final events = loadedState.events;
            final isAgentOnline = loadedState.agentOnline;
            final isChatFinalized = loadedState.isChatFinalized;
            final room = loadedState.currentRoom;
            final userId = context.watch<Globalcubit>().state.user!.id;

            return Stack(
              children: [
                Column(
                  children: [
                    // Cabecera
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: SchemaColors.secondary100,
                                child: Icon(Icons.person, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Agente de soporte", style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    isAgentOnline ? "Conectado" : "Desconectado",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isAgentOnline ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CustomIconButton(
                            icon: LucideIcons.powerOff,
                            message: "Finalizar chat",
                            backgroundColor: SchemaColors.error,
                            onPressed: () => context.read<ChatBloc>().add(ChatEvents.disconnect()),
                          ),
                        ],
                      ),
                    ),

                    // Lista de eventos
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final evt = events[index];

                          return evt.when(
                            chatMessage: (message, from) {
                              final isUser = from == userId;
                              return Align(
                                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUser ? "Tú" : "Agente Soporte",
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isUser ? SchemaColors.primary100 : SchemaColors.secondary100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(message),
                                    ),
                                  ],
                                ),
                              );
                            },
                            systemMessage: (message, from, type) => SystemTextBubble(message, icon: LucideIcons.info, color: SchemaColors.info),
                            assignedAdvisor: (_, __, msg) => SystemTextBubble(msg, icon: LucideIcons.userCheck, color: SchemaColors.success),
                            info: (msg)  => SystemTextBubble(msg, icon: LucideIcons.info, color: SchemaColors.info),
                            noAdvisor: (msg) => SystemTextBubble( msg, icon: LucideIcons.alertTriangle, color: Colors.orangeAccent),
                            error: (msg) => SystemTextBubble( msg, icon: LucideIcons.alertCircle, color: SchemaColors.error),
                          );
                        },
                      ),
                    ),

                    // Input de mensaje
                    if (!isChatFinalized)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                controller: messageController,
                                enabled: isAgentOnline,
                                hintText: isAgentOnline ? 'Escribe un mensaje...' : 'Esperando al agente',
                                isPassword: false,
                                onSubmitted: (_) {
                                  if (room != null) {
                                    sendMessage(context, room, userId, messageController);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: SchemaColors.primary300,
                              ),
                              child: IconButton(
                                onPressed: isAgentOnline && room != null ? () => sendMessage(context, room, userId, messageController) : null,
                                icon: const Icon(LucideIcons.send, size: 20,),
                                color: SchemaColors.neutral,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
