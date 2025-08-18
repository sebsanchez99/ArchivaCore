import 'package:file_picker/file_picker.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/typedefs.dart';

abstract class AIRepository {
  HttpFuture<ServerResponseModel> analizeHV(PlatformFile file, String hvText);
}