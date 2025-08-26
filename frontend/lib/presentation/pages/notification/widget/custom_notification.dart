import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:intl/intl.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String details;
  final String date;
  final bool readed;
  final VoidCallback onDelete;

  const CustomNotification({
    super.key,
    required this.title,
    required this.details,
    required this.date,
    required this.readed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.parse(date));
    return Card(
      color: SchemaColors.neutral500,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundColor: SchemaColors.neutral700,
          child:
              readed
                  ? Icon(Icons.mail, color: SchemaColors.highlight)
                  : Icon(
                    Icons.mark_email_unread,
                    color: SchemaColors.secondary,
                  ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details),
            const SizedBox(height: 4),
            Text(
              formatedDate,
              style: const TextStyle(
                fontSize: 12,
                color: SchemaColors.neutral900,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: SchemaColors.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
