import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class CustomPopupMenu<T> extends StatelessWidget {
  final Widget? child;
  final IconData? icon;
  final List<PopupMenuEntry<T>> items;
  final void Function(T)? onSelected;
  final double width;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? iconColor;

  const CustomPopupMenu({
    super.key,
    this.child,
    this.icon,
    required this.items,
    this.onSelected,
    this.width = 160,
    this.backgroundColor,
    this.hoverColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? SchemaColors.neutral400;
    final iColor = iconColor ?? theme.iconTheme.color;

    return SizedBox(
      width: width,
      child: PopupMenuButton<T>(
        padding: EdgeInsets.zero,
        tooltip: 'Opciones',
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
              textStyle: TextStyle(fontSize: 14),
              child: InkWell(
                onTap: () => onSelected?.call(item.value as T),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: item.child,
                ),
              ),
            );
          }
          return item;
        }).toList(),
        color: bgColor,
        child: child,
      ),
    );
  }
}
