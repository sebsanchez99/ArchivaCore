import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/menu_items.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sideMenuCubit = context.read<SideMenuCubit>();

    return BlocBuilder<SideMenuCubit, int>(
      builder: (context, state) {
        return SideMenu(
          controller: sideMenuCubit.sideMenuController,
          items:
              menuItems.entries.map((item) {
                return SideMenuItem(
                  title: item.value["title"],
                  icon: item.value["icon"],
                  onTap: (index, sideMenuController) => sideMenuCubit.selectIndex(index),
                );
              }).toList(),
        );
      },
    );
  }
}
