import 'package:file_picker/file_picker.dart';
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
  factory FileExplorerEvents.filterContent({
    required String fileName,
  }) = FilterContentEvent;

  // Actualizar un archivo
  factory FileExplorerEvents.putFile({
    required String fileName,
    required String currentRoute,
    required String newRoute,
  }) = PutFileEvent;

  factory FileExplorerEvents.putFolder({
    required String folderName,
    required String currentRoute,
    required String newRoute,
  }) = PutFolderEvent;

  // Eliminar archivo
  factory FileExplorerEvents.deleteFiles({
    required String filePath,
  }) = DeleteFileEvent;

  factory FileExplorerEvents.deleteFolder({
    required String folderPath,
  }) = DeleteFolderEvent;

  //Cargar carpetas en memoria (para GridExplorerBloc)
  factory FileExplorerEvents.loadFolders({
    required List<FolderModel> folders,
  }) = LoadFoldersEvent;

  //Cargar archivos 
  factory FileExplorerEvents.loadFiles({
    required List<FileModel> files,
  }) = LoadFilesEvent;

    factory FileExplorerEvents.selectFile({
    required FileModel file,
  }) = SelectFileEvent;

  factory FileExplorerEvents.selectFolder({
    required FolderModel folder,
  }) = SelectFolderEvent;

  const factory FileExplorerEvents.uploadFile(PlatformFile? result) = UploadFileEvent;
  
  const factory FileExplorerEvents.createFile({required String folderRoute}) = CreateFileEvent;


  // Crear carpeta
  factory FileExplorerEvents.createFolder({
    required String folderName,
    required String routefolder,
  }) = CreateFolderEvent;

  factory FileExplorerEvents.deleteResponse() = DeleteResponseEvent;
  factory FileExplorerEvents.downloadFile({required String filePath}) = DownloadFileEvent;
    factory FileExplorerEvents.filterByTypesAndAuthors({
    required Set<String> selectedTypes,
    required Set<String> selectedAuthors,
  }) = FilterByTypesAndAuthorsEvent;
}
