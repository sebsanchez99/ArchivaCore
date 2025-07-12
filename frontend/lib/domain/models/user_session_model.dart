// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session_model.freezed.dart';
part 'user_session_model.g.dart';

@freezed
class UserSessionModel with _$UserSessionModel {
  const factory UserSessionModel({
    @JsonKey(name: 'userId') required String id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'userRole') required String role,
    @JsonKey(name: 'companyName') required String companyName,
  }) = _UserSessionModel;

  factory UserSessionModel.fromJson(Map<String, dynamic> json) => _$UserSessionModelFromJson(json);
}
