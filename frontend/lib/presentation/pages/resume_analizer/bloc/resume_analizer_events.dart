import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_analizer_events.freezed.dart';

@freezed
class ResumeAnalizerEvents with _$ResumeAnalizerEvents {
  const factory ResumeAnalizerEvents.initialize() = InitializeEvent;
  const factory ResumeAnalizerEvents.analyze() = AnalyzeEvent;
  const factory ResumeAnalizerEvents.uploadFile(PlatformFile? result) = UploadFileEvent;
  const factory ResumeAnalizerEvents.getOfferText(String offerText) = GetOfferTextEvent;
  const factory ResumeAnalizerEvents.loading(bool loading) = LoadingEvent;
}