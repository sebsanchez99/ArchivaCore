import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

class SideMenuCubit extends Cubit<int> {
  //Controlador de saltos entre vistas
  final PageController pageController = PageController(); 
  //Controlador que indica la vista
  final SideMenuController sideMenuController = SideMenuController();

  SideMenuCubit() : super(0) {
    sideMenuController.addListener((index) {
      emit(index);
      pageController.jumpToPage(index);
    });
  }

  //Metodo que selecciona la vista del menu 
  void selectIndex(int index) {
    emit(index);
    pageController.jumpToPage(index);
    sideMenuController.changePage(index);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
