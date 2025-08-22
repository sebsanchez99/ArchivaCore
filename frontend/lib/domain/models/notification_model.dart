// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  factory NotificationModel({
    @JsonKey(name: 'Not_ID') required String id,
    @JsonKey(name: 'Not_Titulo') required String title,
    @JsonKey(name: 'Not_Mensaje') required String message,
    @JsonKey(name: 'Not_Fecha') required String date,
    @JsonKey(name: 'NotUsu_Recibida') required bool readed,

  }) = _NotificationModel;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}