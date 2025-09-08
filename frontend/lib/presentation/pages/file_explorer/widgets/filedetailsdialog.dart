import 'package:flutter/material.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/filedetails.dart';

class FileDetailsDialog extends StatelessWidget {
  const FileDetailsDialog({
    super.key,
    required this.file,
    required this.bloc,
  });
  final FileModel file;
  final FileExplorerBloc bloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: SchemaColors.neutral100,
      content: SizedBox(
        width: 750,
        child: FileDetails(file: file, bloc: bloc)
      ),
    );
  }
}