// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coincident_skill_model.freezed.dart';
part 'coincident_skill_model.g.dart';

@freezed
class CoincidentSkillModel with _$CoincidentSkillModel {
  factory CoincidentSkillModel({
    @JsonKey(name: "skill") required String skill,
    @JsonKey(name: "categoria") required String category,
    @JsonKey(name: "evidenciaCV") required String evidenceCV,
  }) = _CoincidentSkillModel;

  factory CoincidentSkillModel.fromJson(Map<String, dynamic> json) =>  _$CoincidentSkillModelFromJson(json);
}