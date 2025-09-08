import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/attach_file.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/create_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/edit_folder.dart';

Future<void> showCreateFolderDialog(BuildContext context) async {
  final bloc = context.read<FileExplorerBloc>();
  final state = bloc.state;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: state.maybeWhen(
          loaded: (viewType, folders, filteredFolders, response) {
            return CreateFolder(path: folders);
          },
          orElse: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    },
  );
}

Future<void> showEditFolderDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const EditFolder(),
  );
}

Future<void> showAttachFolderDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const AttachFile(),
  );
}
