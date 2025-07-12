import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user_session_model.dart';

part 'global_state.freezed.dart';

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState({
    UserSessionModel? user,
  }) = _GlobalState;
}