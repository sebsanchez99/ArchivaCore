import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/cv_analysis_model.dart';
import 'package:frontend/domain/repositories/ai_repository.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_events.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_state.dart';

class ResumeAnalizerBloc extends Bloc<ResumeAnalizerEvents, ResumeAnalizerState> {
  ResumeAnalizerBloc(super.initialState, {
    required AIRepository aiRepository
  }) : _aiRepository = aiRepository {
    on<AnalyzeEvent>(_onAnalyze);
    on<UploadFileEvent>(_onUploadFile);
    on<GetOfferTextEvent>(_onGetOfferTextEvent);
    on<LoadingEvent>(_onLoadingEvent);
  }

  final AIRepository _aiRepository;

  Future<void> _onAnalyze(AnalyzeEvent event, Emitter<ResumeAnalizerState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        final result =  await _aiRepository.analizeHV(value.file!, value.offerText);
         emit(
          result.when(
            right: (response){
              CVAnalysisModel? aiResponse;
              if (response.result && response.data != null) {
                aiResponse = CVAnalysisModel.fromJson(response.data as Map<String, dynamic>);
              } else {
                aiResponse = null;
              }
              return ResumeAnalizerState.loaded(response: aiResponse, serverResponse: response, loading: false);
            }, 
            left: (failure) => ResumeAnalizerState.failed(failure),
          ),
        );
      },
    );
  }

  Future<void> _onUploadFile(UploadFileEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(file: event.result))
    );
  }

  Future<void> _onGetOfferTextEvent(GetOfferTextEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(offerText: event.offerText))
    );
  }

  Future<void> _onLoadingEvent(LoadingEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(loading: event.loading))
    );
  }
  
}