import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/enums/file_explorer_view_type.dart';

part 'file_explorer_events.freezed.dart';

@freezed
class FileExplorerEvents with _$FileExplorerEvents {
  //Evento inicial de la vista
  factory FileExplorerEvents.initialize() = InitializeEvent;
  factory FileExplorerEvents.changeView({ required FileExplorerViewType viewType }) = ChangeViewTypeEvent;
  factory FileExplorerEvents.filterFiles({required String fileName}) = FilterFilesEvent;

  //Evento que actualiza a los archivos
  factory FileExplorerEvents.putFiles({
    required String fileID,
    required String fileName,
  }) = PutFileEvent;

  //Evento que crea a los archivos
  factory FileExplorerEvents.createFiles({required String fileName}) = CreateFileEvent;

  //Evento que elimina a los archivos
  factory FileExplorerEvents.deleteFiles({required String fileID}) = DeleteFileEvent;
}
