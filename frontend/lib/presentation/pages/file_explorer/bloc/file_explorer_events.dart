import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/file_model.dart';

part 'file_explorer_events.freezed.dart';

@freezed
class FileExplorerEvents with _$FileExplorerEvents {
  // Evento inicial de la vista
  factory FileExplorerEvents.initialize() = InitializeEvent;

  // Cambio de vista (grid, list, details, etc.)
  factory FileExplorerEvents.changeView({
    required FileExplorerViewType viewType,
  }) = ChangeViewTypeEvent;

  // Filtrar archivos por nombre
  factory FileExplorerEvents.filterFiles({
    required String fileName,
  }) = FilterFilesEvent;

  // Actualizar un archivo
  factory FileExplorerEvents.putFiles({
    required String fileID,
    required String fileName,
  }) = PutFileEvent;

  // Crear archivo
  factory FileExplorerEvents.createFiles({
    required String fileName,
  }) = CreateFileEvent;

  // Eliminar archivo
  factory FileExplorerEvents.deleteFiles({
    required String fileID,
  }) = DeleteFileEvent;

  //Cargar carpetas en memoria (para GridExplorerBloc)
  factory FileExplorerEvents.loadFolders({
    required List<FolderModel> folders,
  }) = LoadFoldersEvent;

  //Cargar archivos (si quieres exponerlos directo)
  factory FileExplorerEvents.loadFiles({
    required List<FileModel> files,
  }) = LoadFilesEvent;
}
