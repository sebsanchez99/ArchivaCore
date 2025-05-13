import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_events.freezed.dart';

@freezed
class FolderEvents with _$FolderEvents {
  //Evento inicial de la vista
  factory FolderEvents.initialize() = InitializeEvent;
  factory FolderEvents.filterFolders({required String folderName}) =
      FilterFoldersEvent;

  //Evento que actualiza a las carpetas
  factory FolderEvents.putFolders({
    required String folderID,
    required String folderName,
  }) = PutFolderEvent;

  //Evento que crea a las carpetas
  factory FolderEvents.createFolders({required String folderName}) =
      CreateFolderEvent;

  //Evento que elimina a las carpetas
  factory FolderEvents.deleteFolders({required String folderID}) =
      DeleteFolderEvent;
  
}