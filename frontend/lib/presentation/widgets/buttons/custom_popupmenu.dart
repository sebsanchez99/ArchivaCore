import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomPopupMenu<T> extends StatelessWidget {
  final Widget? child;
  final IconData? icon;
  final List<PopupMenuEntry<T>> items;
  final void Function(T)? onSelected;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? iconColor;
  final String tooltip;

  const CustomPopupMenu({
    super.key,
    this.child,
    this.icon,
    required this.items,
    this.onSelected,
    this.backgroundColor,
    this.hoverColor,
    this.iconColor,
    this.tooltip = 'Opciones',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? SchemaColors.neutral400;
    final iColor = iconColor ?? theme.iconTheme.color;

    return PopupMenuButton<T>(
      
      padding: EdgeInsets.zero,
      tooltip: tooltip,
      icon: icon != null ? Icon(icon, color: iColor) : null,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      itemBuilder: (_) => items.map((item) {
        if (item is PopupMenuItem<T>) {
          return PopupMenuItem<T>(
            value: item.value,
            mouseCursor: SystemMouseCursors.click,
            height: 40,
            textStyle: const TextStyle(fontSize: 14),
            child: InkWell(
              onTap: () => onSelected?.call(item.value as T),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                alignment: Alignment.centerLeft,
                child: item.child, // Aquí está el widget que necesitas corregir
              ),
            ),
          );
        }
        return item;
      }).toList(),
      color: bgColor,
      child: child,
    );
  }
}