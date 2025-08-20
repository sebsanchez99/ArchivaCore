import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final String level;

  const LevelIndicator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (level) {
      case "Alto":
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case "Medio":
        icon = Icons.trending_flat;
        color = Colors.orange;
        break;
      case "Bajo":
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          level,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
