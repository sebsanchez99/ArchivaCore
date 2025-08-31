import 'package:freezed_annotation/freezed_annotation.dart';

part 'recycle_events.freezed.dart';

@freezed
class RecycleEvents with _$RecycleEvents {
  factory RecycleEvents.initialize() = InitializeEvent;
  factory RecycleEvents.filterContent({ required String elementName }) = FilterContentEvent;
  factory RecycleEvents.restoreFile({ required String filePath }) = RestoreFileEvent;
  factory RecycleEvents.restoreFolder({ required String folderPath }) = RestoreFolderEvent;
  factory RecycleEvents.deleteFile({ required String filePath }) = DeleteFileEvent;
  factory RecycleEvents.deleteFolder({ required String folderPath }) = DeleteFolderEvent;
  factory RecycleEvents.emptyRecycleFolder() = EmptyRecycleFolder;
}