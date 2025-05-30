import 'package:flutter/material.dart';

class ImprovementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const ImprovementItem({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.orange.shade500, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        )
      ],
    );
  }
}