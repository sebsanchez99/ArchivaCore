import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/failures/http_request_failure.dart';

part 'resume_analizer_state.freezed.dart';

@freezed
class ResumeAnalizerState with _$ResumeAnalizerState {
  const factory ResumeAnalizerState.loading() = _LoadingState;
  const factory ResumeAnalizerState.loaded() = _LoadedState;
  const factory ResumeAnalizerState.failed(HttpRequestFailure failure) = _FailedState;
}