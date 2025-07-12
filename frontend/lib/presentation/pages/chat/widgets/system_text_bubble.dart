import 'package:flutter/material.dart';

class SystemTextBubble extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const SystemTextBubble(this.text, {super.key, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (color ?? Colors.grey.shade200).withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color ?? Colors.grey.shade400),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: 14, color: color ?? Colors.black87),
            if (icon != null) const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: color ?? Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}