import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/user_session_model.dart';
import 'package:frontend/presentation/global/cubit/global_state.dart';
import 'package:frontend/utils/secure_storage.dart';


class Globalcubit extends Cubit<GlobalState> {
  final GlobalKey<NavigatorState> navigatorKey;
  Globalcubit(this.navigatorKey) : super(const GlobalState());

  void setUser(UserSessionModel user) => emit(state.copyWith(user: user));

  Future<void> logout() async {
    await SecureStorage().deleteToken();
    emit(const GlobalState());
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
  }
}