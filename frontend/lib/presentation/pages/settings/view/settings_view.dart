import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:frontend/presentation/widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Row(
            children: [
              const Icon(LucideIcons.shield, color: SchemaColors.info),
              const SizedBox(width: 8),
              const Text(
                'Seguridad',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Configuraciones de seguridad y contraseña',
            style: TextStyle(color: SchemaColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Contraseña actual
          const Text("Contraseña actual", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          CustomInput(
            isPassword: true,
          ),
          const SizedBox(height: 24),
          // Nueva y confirmar contraseña
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Nueva contraseña", style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    CustomInput(
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Confirmar contraseña", style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    CustomInput(
                      isPassword: true,
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recomendaciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SchemaColors.neutral600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.shieldQuestion, color: SchemaColors.info),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recomendaciones de seguridad", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("• Usa al menos 8 caracteres"),
                      Text("• Incluye mayúsculas, minúsculas y números"),
                      Text("• Evita información personal"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Botón
          SizedBox(
            width: 250,
            height: 45,
            child: CustomIconButton(
              message: 'Cambiar contraseña', 
              icon: LucideIcons.shieldCheck, 
              onPressed: (){}
            ),
          ),
        ],
      ),
    );
  }
}
