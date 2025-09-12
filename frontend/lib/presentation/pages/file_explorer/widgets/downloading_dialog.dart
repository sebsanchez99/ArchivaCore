import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class DownloadingDialog extends StatelessWidget {
  final String message;

  const DownloadingDialog({
    super.key,
    this.message = 'Descargando archivo...',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.download, size: 40, color: SchemaColors.info,),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const LoadingState(),
        ],
      ),
    );
  }
}