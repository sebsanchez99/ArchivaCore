import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/folder_response.dart';
import 'package:frontend/domain/models/server_response_model.dart';


part 'recycle_state.freezed.dart';

@freezed
class RecycleState with _$RecycleState {
  factory RecycleState.loading() = _LoadingState;
  factory RecycleState.loaded({
    @Default(FolderResponse(folders: [], files: [])) FolderResponse content,
    @Default(FolderResponse(folders: [], files: [])) FolderResponse filteredContent,
    ServerResponseModel? response
  }) = _LoadedState;
  factory RecycleState.failed(HttpRequestFailure failure) = _FailedState;
}