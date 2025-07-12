// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_status_model.freezed.dart';
part 'agent_status_model.g.dart';

@freezed
class AgentStatusModel with _$AgentStatusModel {
  const factory AgentStatusModel({
    @JsonKey(name: 'empresaId') required String companyId,
    @JsonKey(name: 'online') required bool online,
  }) = _AgentStatusModel;

  factory AgentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AgentStatusModelFromJson(json);

  factory AgentStatusModel.fromList(List<dynamic> data) {
    if (data.length != 2 || data[0] is! bool || data[1] is! String) {
      throw FormatException('Lista inválida para AgentStatusModel: $data');
    }

    return AgentStatusModel(
      online: data[0] as bool,
      companyId: data[1] as String,
    );
  }
}

