import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/menu_items.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SideMenuCubit(),
      child: BlocBuilder<SideMenuCubit, SideMenuState>(
        builder: (context, state) {
          final sideMenuCubit = context.read<SideMenuCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: SchemaColors.primary,
              leading: IconButton(
                onPressed: () => sideMenuCubit.toggleMenu(),
                icon: Icon(Icons.menu, color: SchemaColors.neutral),
              ),
              actions: [
                IconButton(
                  onPressed: () =>{},
                  icon: Icon(Icons.notifications, color: SchemaColors.neutral),
                ),
              ],
            ),
            body: Row(
              children: [
                SideMenuWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: sideMenuCubit.pageController,
                      children:
                          menuItems.values
                              .map((item) => item['widget'] as Widget)
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
