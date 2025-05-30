import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final Color color;
  const SkillChip({
    super.key, 
    required this.label, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      side: BorderSide(style: BorderStyle.none),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w400),
    );
  }
}