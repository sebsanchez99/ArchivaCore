import 'package:flutter/widgets.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_bloc.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_events.dart';
import 'package:provider/provider.dart';

void sendMessage(BuildContext context, String room, String userId, TextEditingController messageController) {
  final text = messageController.text.trim();
  if (text.isEmpty) return;
  context.read<ChatBloc>().add(ChatEvents.sendMessage(room: room, message: text, fromUserId: userId));
}

void scrollToBottom(ScrollController scrollController) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}