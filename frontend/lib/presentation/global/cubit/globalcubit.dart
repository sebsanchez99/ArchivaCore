import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/utils/secure_storage.dart';


class Globalcubit extends Cubit<void> {
  final GlobalKey<NavigatorState> navigatorKey;
  Globalcubit(this.navigatorKey) : super(null);

  Future<void> logout() async {
    await SecureStorage().deleteToken();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
  }
}