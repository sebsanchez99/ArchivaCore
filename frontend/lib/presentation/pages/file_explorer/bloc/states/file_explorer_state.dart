import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/file_model.dart';
import 'package:frontend/domain/models/folder_model.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/presentation/enums/file_explorer_view_type.dart';

part 'file_explorer_state.freezed.dart';

@freezed
class FileExplorerState with _$FileExplorerState {
  //Estado de cargando de la vista de archivos
  factory FileExplorerState.loading() = _LoadingState;
  //Estado de cargado de la vista de archivos
  factory FileExplorerState.loaded({
    required FileExplorerViewType viewType,
    @Default(<String>{}) Set<String> selectedTypes,
    @Default(<String>{}) Set<String> selectedAuthors,
    @Default(FolderResponse(folders: [], files: [])) FolderResponse content,
    @Default(FolderResponse(folders: [], files: [])) FolderResponse filteredContent,
    @Default([]) List<String> allTypes,
    @Default([]) List<String> allAuthors,
    ServerResponseModel? response,
    FileModel? selectedFile,
    FolderModel? selectedFolder,
    PlatformFile? file,
  }) = _LoadedState;
  //Estado de falla de la vista de archivos
  factory FileExplorerState.failed(HttpRequestFailure failure) = _FailedState;
} 
