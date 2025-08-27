// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  factory NotificationModel({
    @JsonKey(name: 'not_id') required String id,
    @JsonKey(name: 'titulo') required String title,
    @JsonKey(name: 'mensaje') required String message,
    @JsonKey(name: 'fecha') required String date,
    @JsonKey(name: 'recibida') required bool readed,

  }) = _NotificationModel;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}