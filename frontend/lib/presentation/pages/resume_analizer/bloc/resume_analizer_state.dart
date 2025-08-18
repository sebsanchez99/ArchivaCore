import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';
import 'package:frontend/domain/models/cv_analysis_model.dart';
import 'package:frontend/domain/models/server_response_model.dart';

part 'resume_analizer_state.freezed.dart';

@freezed
class ResumeAnalizerState with _$ResumeAnalizerState {
  const factory ResumeAnalizerState.loaded({
    @Default('') String offerText,
    @Default(false) bool loading,
    PlatformFile? file,
    CVAnalysisModel? response,
    ServerResponseModel? serverResponse,
  }) = _LoadedState;
  const factory ResumeAnalizerState.failed(HttpRequestFailure failure) = _FailedState;
}