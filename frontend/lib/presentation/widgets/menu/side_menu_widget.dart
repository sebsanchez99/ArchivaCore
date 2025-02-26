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
          title: Center(child: Icon(Icons.abc, size: 70,)), 
        
          style: SideMenuStyle(
            showHamburger: true, 
            backgroundColor: Color(0xFFE7E9ED),
            hoverColor: Color(0xFFF3F4F6),
            selectedColor: Color(0xFFD1D5DB),
            selectedTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B3642),
            ),
            selectedIconColor: Color(0xFF3A5A98),
            unselectedIconColor: Colors.grey,
            unselectedTitleTextStyle: TextStyle(color: Color(0xFF394958)),
            itemBorderRadius: BorderRadius.circular(12),
            itemOuterPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 4,), 
            itemInnerSpacing: 10,
            ),

            items:
            menuItems.entries.map((item) {
                return SideMenuItem(
                  title: item.value["title"],
                  icon: item.value["icon"],
                  onTap:
                      (index, sideMenuController) =>
                          sideMenuCubit.selectIndex(index),
                );
              }).toList(),
        );
      },
    );
  }
}
