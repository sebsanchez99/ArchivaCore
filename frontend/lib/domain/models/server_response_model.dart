import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_response_model.freezed.dart';
part 'server_response_model.g.dart';

@freezed
class ServerResponseModel with _$ServerResponseModel {
  factory ServerResponseModel({
    required bool result,
    required String message,
    dynamic data
  }) = _ServerReponseModel;

  factory ServerResponseModel.fromJson(Map<String, dynamic> json) => _$ServerResponseModelFromJson(json);
}

