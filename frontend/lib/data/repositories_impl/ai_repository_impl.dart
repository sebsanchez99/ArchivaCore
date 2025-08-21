import 'package:file_picker/file_picker.dart';
import 'package:frontend/data/services/remote/ai_service.dart';
import 'package:frontend/domain/models/server_response_model.dart';
import 'package:frontend/domain/repositories/ai_repository.dart';
import 'package:frontend/domain/typedefs.dart';

class AIRepositoryImpl extends AIRepository {
  final AIService _aiService;

  AIRepositoryImpl(this._aiService);

  @override
  HttpFuture<ServerResponseModel> analizeHV(PlatformFile hvFile, String offerText, ) async {
    return await _aiService.analizeHV(offerText, hvFile);
  }
  
}