// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/coincident_skill_model.dart';

part 'evidence_matrix_model.freezed.dart';
part 'evidence_matrix_model.g.dart';

@freezed
class EvidenceMatrixModel with _$EvidenceMatrixModel {
  factory EvidenceMatrixModel({
    @JsonKey(name: "skillsCoincidentes") required List<CoincidentSkillModel> coincidenceSkill,
    @JsonKey(name: "skillsFaltantes") required List<String> missingSkills,
  }) = _EvidenceMatrixModel;

  factory EvidenceMatrixModel.fromJson(Map<String, dynamic> json) =>  _$EvidenceMatrixModelFromJson(json);
}