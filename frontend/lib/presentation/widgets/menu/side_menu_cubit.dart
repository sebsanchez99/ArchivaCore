import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:frontend/presentation/global/constants/menu_items.dart'; // Import the menuItems map
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';

class SideMenuCubit extends Cubit<SideMenuState> {
  final PageController pageController = PageController();
  final SideMenuController sideMenuController = SideMenuController();

  late final List<MapEntry<int, Map<String, dynamic>>> _filteredMenuItems;
  late final List<Widget> filteredViews;

  SideMenuCubit(String? userRole) : super(SideMenuState()) {
    _filteredMenuItems = menuItems.entries.where((item) {
      final roles = item.value['roles'] as List<String>?;
      return roles?.contains(userRole) ?? true;
    }).toList();

    filteredViews = _filteredMenuItems.map((item) => item.value['widget'] as Widget).toList();

    sideMenuController.addListener((index) {
      if (index != -1 && index < filteredViews.length) {
        pageController.jumpToPage(index);
        emit(state.copyWith(selectedIndex: index));
      }
    });
  }
  
  void navigateTo(String itemTitle) {
    final originalEntry = menuItems.entries.firstWhere(
      (e) => e.value['title'] == itemTitle,
    );

    final visualIndex = _filteredMenuItems.indexWhere(
      (e) => e.key == originalEntry.key,
    );

    if (visualIndex != -1) {
      pageController.jumpToPage(visualIndex);
      sideMenuController.changePage(visualIndex);
      emit(state.copyWith(selectedIndex: visualIndex));
    }
  }

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