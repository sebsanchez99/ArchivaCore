import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/constants/menu_items.dart';
import 'package:frontend/presentation/constants/schema_colors.dart';
import 'package:frontend/presentation/global/cubit/globalcubit.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sideMenuCubit = context.read<SideMenuCubit>();

    return BlocBuilder<SideMenuCubit, SideMenuState>(
      builder: (context, state) {
        return SideMenu(
          controller: sideMenuCubit.sideMenuController,
          title: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 110, maxHeight: 110),
                child: Image.asset('assets/images/logo.png'),
              ),
              Divider(indent: 8, endIndent: 8, color: SchemaColors.neutral),
            ],
          ),
          displayModeToggleDuration: Duration(milliseconds: 250),

          style: SideMenuStyle(
            itemHeight: 40,
            iconSize: 20,
            displayMode: state.displayMode,
            openSideMenuWidth: 250,
            backgroundColor: SchemaColors.primary,
            hoverColor: SchemaColors.primary400,
            selectedColor: SchemaColors.primary400,
            selectedTitleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: SchemaColors.primary700,
            ),
            selectedIconColor: SchemaColors.primary800,
            unselectedIconColor: SchemaColors.neutral,
            unselectedTitleTextStyle: const TextStyle(
              color: SchemaColors.neutral,
              fontWeight: FontWeight.bold, 
            ),
            itemBorderRadius: BorderRadius.circular(12),
            itemOuterPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),

          items: [
            ...menuItems.entries.map((item) {
            return SideMenuItem(
              title: item.value["title"],
              icon: item.value["icon"],
              onTap: (index, sideMenuController) => sideMenuCubit.selectIndex(index),
            );
            }),
            SideMenuItem(             
              builder: (context, displayMode) => SizedBox(height: 40),
            ),
            SideMenuItem(             
              title: 'Cerrar sesión',
              icon: Icon(Icons.logout),
              onTap: (index, sideMenuController) => context.read<Globalcubit>().logout(),
            ),
          ],

        );
      },
    );
  }
}
