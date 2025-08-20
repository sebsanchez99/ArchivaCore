import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/cv_analysis_model.dart';
import 'package:frontend/domain/repositories/ai_repository.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_events.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_state.dart';

class ResumeAnalizerBloc extends Bloc<ResumeAnalizerEvents, ResumeAnalizerState> {
  final ScrollController scrollController = ScrollController();
  final cardKey = GlobalKey();

  ResumeAnalizerBloc(super.initialState, {
    required AIRepository aiRepository
  }) : _aiRepository = aiRepository {
  
    on<AnalyzeEvent>(_onAnalyze);
    on<UploadFileEvent>(_onUploadFile);
    on<GetOfferTextEvent>(_onGetOfferTextEvent);
    on<LoadingEvent>(_onLoadingEvent);
    on<ScrollingEvent>(_onMarkAsScrolled);
    on<ScrollEvent>(_onScrollEvent);
    on<ResetResponseEvent>(_onResetResponseEvent);
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

  Future<void> _onMarkAsScrolled(ScrollingEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(scrolled: event.scrolling))
    );
  }

  Future<void> _onResetResponseEvent(ResetResponseEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.mapOrNull(
      loaded: (value) => emit(value.copyWith(serverResponse: null))
    );
  }

  Future<void> _onScrollEvent(ScrollEvent event, Emitter<ResumeAnalizerState> emit) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (cardKey.currentContext != null) {
        await Scrollable.ensureVisible(
          cardKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        state.mapOrNull(
          loaded: (_) => add(const ScrollingEvent(true)), 
        );
      }
    });
  }
}