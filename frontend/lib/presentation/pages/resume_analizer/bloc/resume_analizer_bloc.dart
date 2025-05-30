import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_events.dart';
import 'package:frontend/presentation/pages/resume_analizer/bloc/resume_analizer_state.dart';

class ResumeAnalizerBloc extends Bloc<ResumeAnalizerEvents, ResumeAnalizerState> {
  ResumeAnalizerBloc(super.initialState) {
    on<InitializeEvent>(_onInitialize);
    on<AnalyzeEvent>(_onAnalyze);
    on<UploadFileEvent>(_onUploadFile);
  }

  Future<void> _onInitialize(InitializeEvent event, Emitter<ResumeAnalizerState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(ResumeAnalizerState.loading()),
    );
    emit(ResumeAnalizerState.loaded());
  }

  Future<void> _onAnalyze(AnalyzeEvent event, Emitter<ResumeAnalizerState> emit) async {
    // TODO: Implement resume analysis logic here
  }

  Future<void> _onUploadFile(UploadFileEvent event, Emitter<ResumeAnalizerState> emit) async {
    // TODO: Implement file upload logic here
  }
  
}