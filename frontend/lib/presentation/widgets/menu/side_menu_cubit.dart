import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';

class SideMenuCubit extends Cubit<SideMenuState> {
  //Controlador de saltos entre vistas
  final PageController pageController = PageController();
  //Controlador que indica la vista
  final SideMenuController sideMenuController = SideMenuController();

  SideMenuCubit() : super(SideMenuState()) {
    sideMenuController.addListener((index) {
      emit(state.copyWith(selectedIndex: index));
      pageController.jumpToPage(index);
    });
  }

  //Método que selecciona la vista del menú
  void selectIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
    pageController.jumpToPage(index);
    sideMenuController.changePage(index);
  }

  //Método que cambia el estado del menú
  void toggleMenu() {
    final displayMode = (state.displayMode == SideMenuDisplayMode.auto) ? SideMenuDisplayMode.compact : SideMenuDisplayMode.auto;
    emit(state.copyWith(displayMode: displayMode));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
