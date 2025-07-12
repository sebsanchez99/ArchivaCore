import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/global/cubit/globalcubit.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_bloc.dart';
import 'package:frontend/presentation/pages/chat/bloc/chat_events.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';

class ChatInitialView extends StatelessWidget {
  const ChatInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<Globalcubit>().state.user;
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: SchemaColors.secondary100,
            child: Icon(Icons.person, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text("Soporte instantáneo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text(
            "Nuestros agentes de soporte están disponibles\npara ayudarlo con cualquier pregunta o problema.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: SchemaColors.primary100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.access_time, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                Text("Lunes a Viernes: 9:00 AM - 5:00 PM"),
              ],
            ),
          ),
          const SizedBox(height: 40),
          CustomIconButton(
            icon: Icons.power_settings_new,
            backgroundColor: SchemaColors.success,
            message: "Iniciar chat ahora",
            onPressed: () => context.read<ChatBloc>().add( ChatEvents.connect(userId: user!.id, role: user.role, companyName: user.companyName)),
          ),
        ],
      ),
    );
  }
}
