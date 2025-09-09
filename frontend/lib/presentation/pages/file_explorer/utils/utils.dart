import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/blocs/file_explorer_bloc.dart';
import 'package:frontend/presentation/pages/file_explorer/bloc/events/file_explorer_events.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/attach_file.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/create_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/edit_file.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/edit_folder.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/filedetailsdialog.dart';
import 'package:frontend/presentation/pages/file_explorer/widgets/folderdetailsdialog.dart';
import 'package:frontend/presentation/widgets/dialogs/error_dialog.dart';
import 'package:frontend/presentation/widgets/dialogs/info_dialog.dart';

Future<void> showCreateFolderDialog(BuildContext context) async {
  final bloc = context.read<FileExplorerBloc>();
  final state = bloc.state;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: state.maybeMap(
          loaded: (value) {
            return CreateFolder(path: value.folders);
          },
          orElse: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    },
  );
}

Future<void> showEditFolderDialog(BuildContext context, FolderModel folder, FileExplorerBloc bloc) async {
  
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EditFolder(bloc: bloc, folder: folder),
  );
}

Future<void> showEditFileDialog(BuildContext context, FileModel file, FileExplorerBloc bloc) async {
  return showDialog(
    context: context,
    builder: (context) => EditFile(file: file, bloc: bloc),
  );
}

Future<void> showAttachFolderDialog(BuildContext context, FileExplorerBloc bloc) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AttachFile(bloc: bloc),
  );
}

Future<void> showFileDetailsDialog(BuildContext context, FileModel file) async {
  final bloc = context.read<FileExplorerBloc>();
  return showDialog(
    context: context,
    builder: (context) => FileDetailsDialog(file: file, bloc: bloc),
  );
}

Future<void> showFolderDetailsDialog(BuildContext context, FolderModel folder) async {
  final bloc = context.read<FileExplorerBloc>();
  return showDialog(
    context: context,
    builder: (context) => FolderDetailsDialog(folder: folder, bloc: bloc),
  );
}

Future<void> showDeleteFileConfirmationDialog(BuildContext context, FileModel file, FileExplorerBloc bloc) async{
  return showDialog(
    context: context, 
    builder:(context) => InfoDialog(
      message: '¿Desea cambiar eliminar el archivo ${file.name}?',
      onPressed: () {}
      // onPressed: () => bloc.add(DeleteFileEvent(fileID: fileID))
    ),
  );
}

Future<void> showDeleteFolderConfirmationDialog(BuildContext context, FolderModel folder, FileExplorerBloc bloc) async{
  return showDialog(
    context: context, 
    builder:(context) => InfoDialog(
      message: '¿Desea cambiar eliminar la carpeta ${folder.name}?',
      onPressed: () {}
      // onPressed: () => bloc.add(DeleteFileEvent(fileID: fileID))
    ),
  );
}

Future<void> showDownloadFileConfirmationDialog(BuildContext context, FileModel file, FileExplorerBloc bloc) async{
  return showDialog(
    context: context, 
    builder:(context) => InfoDialog(
      message: '¿Desea descargar ${file.name}?',
      onPressed: () {}
      // onPressed: () => bloc.add(DeleteFileEvent(fileID: fileID))
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) async{
  return showDialog(
    context: context, 
    builder:(context) => ErrorDialog(
      message: message
    ),
  );
}

Future<void> pickFile(BuildContext context, FileExplorerBloc bloc) async {
  final result = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['pdf', 'docx', 'txt'], 
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;  
    bloc.add(UploadFileEvent(file)); 
  }
}
