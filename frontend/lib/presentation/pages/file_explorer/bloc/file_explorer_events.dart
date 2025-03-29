import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_explorer_events.freezed.dart';

//Evento inicial de la vista
@freezed
class FileExplorerEvents with _$FileExplorerEvents {
  factory FileExplorerEvents.initialize() = InitializeEvent;
}
