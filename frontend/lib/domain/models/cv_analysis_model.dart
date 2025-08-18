// ignore_for_file: invalid_annotation_target
import "package:freezed_annotation/freezed_annotation.dart";
import "package:frontend/domain/models/evidence_matrix_model.dart";

part 'cv_analysis_model.freezed.dart';
part 'cv_analysis_model.g.dart';

@freezed
class CVAnalysisModel with _$CVAnalysisModel {
  factory CVAnalysisModel({
    @JsonKey(name: "Resumen del perfil") required String resume,
    @JsonKey(name: "Resumen de compatibilidad") required String resumeCompatibility,
    @JsonKey(name: "Compatibilidad") required int compatibility,
    @JsonKey(name: "Experiencia") required int experience,
    @JsonKey(name: "Habilidades") required int skills,
    @JsonKey(name: "Habilidades destacadas") required List<String> outstandingSkills,
    @JsonKey(name: "Áreas de mejora") required List<String> areasOfImprovement,
    @JsonKey(name: "Matriz de evidencias") required EvidenceMatrixModel evidenceMatrix,
    @JsonKey(name: "Motivo del puntaje") required String reasonScore,
    @JsonKey(name: "Nivel") required String level,
  }) = _CVAnalysisModel;

  factory CVAnalysisModel.fromJson(Map<String, dynamic> json) => _$CVAnalysisModelFromJson(json);
}