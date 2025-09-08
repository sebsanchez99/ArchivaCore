import 'package:flutter/material.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folder_details.dart';

class FolderDetailsDialog extends StatelessWidget {
  const FolderDetailsDialog({
    super.key,
    required this.folder,
    required this.bloc,
  });
  final FolderModel folder;
  final FileExplorerBloc bloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: SchemaColors.neutral100,
      content: SizedBox(
        width: 750,
        child: FolderDetails(folder: folder, bloc: bloc)
      ),
    );
  }
}