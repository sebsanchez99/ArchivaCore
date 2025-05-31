import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_analizer_events.freezed.dart';

@freezed
class ResumeAnalizerEvents with _$ResumeAnalizerEvents {
  const factory ResumeAnalizerEvents.initialize() = InitializeEvent;
  const factory ResumeAnalizerEvents.analyze(String resume) = AnalyzeEvent;
  const factory ResumeAnalizerEvents.uploadFile() = UploadFileEvent;
}