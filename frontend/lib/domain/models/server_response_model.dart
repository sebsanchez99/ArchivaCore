import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_response_model.freezed.dart';
part 'server_response_model.g.dart';

/// Modelo que representa respuesta del servidor
@freezed
class ServerResponseModel with _$ServerResponseModel {
  factory ServerResponseModel({
    /// Valor boleano que representa el estado de la operación
    required bool result,
    /// Mensaje de la operación
    required String message,
    /// Datos de la operación, este atributo puede retornar un dato [null]
    dynamic data
  }) = _ServerReponseModel;

  factory ServerResponseModel.fromJson(Map<String, dynamic> json) => _$ServerResponseModelFromJson(json);
}

