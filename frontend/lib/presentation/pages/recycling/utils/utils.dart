part of '../view/recycling_view.dart';

Future<void> _showResult(BuildContext context, ServerResponseModel response) async {
  return showDialog(
    context: context,
    builder: (context) => response.result ? SuccessDialog (message: response.message) : ErrorDialog(message: response.message),
  );
}

Future<void> _showFolderDetailsDialog(BuildContext context, FolderModel folder) async {
  return showDialog(
    context: context, 
    barrierDismissible: true,
    builder: (context) => FolderDetailsWindow(folder: folder),
  );
}

Future<void> _showEmptyRecyclingFolderInfoDialog(BuildContext context) async {
  final bloc =  context.read<RecycleBloc>();
  return showDialog(
    context: context, 
    builder: (context) => InfoDialog(
      message: '¿Desea vaciar la papelera de reciclaje?.', 
      onPressed: () => bloc.add(EmptyRecycleFolder()),
    ),
  );
}

Future<void> _showDeleteFileInfoDialog(BuildContext context, FileModel file) async {
  final bloc =  context.read<RecycleBloc>();
  return showDialog(
    context: context, 
    builder: (context) => InfoDialog(
      message: '¿Desea eliminar definitivamente el archivo ${file.name}?. Esta acción es irreversible.', 
      onPressed: () => bloc.add(DeleteFileEvent(filePath: file.path)),
    ),
  );
}

Future<void> _showDeleteFolderInfoDialog(BuildContext context, FolderModel folder) async {
  final bloc =  context.read<RecycleBloc>();
  return showDialog(
    context: context, 
    builder: (context) => InfoDialog(
      message: '¿Desea eliminar definitivamente la carpeta ${folder.name}?. Esta acción es irreversible.', 
      onPressed: () => bloc.add(DeleteFolderEvent(folderPath: folder.path)),
    ),
  );
}

Future<void> _showRestoreFileInfoDialog(BuildContext context, FileModel file) async {
  final bloc =  context.read<RecycleBloc>();
  return showDialog(
    context: context, 
    builder: (context) => InfoDialog(
      message: '¿Desea restaurar el archivo ${file.name}?', 
      onPressed: () => bloc.add(RestoreFileEvent(filePath: file.path)),
    ),
  );
}

Future<void> _showRestoreFolderInfoDialog(BuildContext context, FolderModel folder) async {
  final bloc =  context.read<RecycleBloc>();
  return showDialog(
    context: context, 
    builder: (context) => InfoDialog(
      message: '¿Desea restaurar el archivo ${folder.name}?', 
      onPressed: () => bloc.add(RestoreFolderEvent(folderPath: folder.path)),
    ),
  );
}

