import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/global/cubit/globalcubit.dart';
import 'package:frontend/presentation/pages/notification/view/notifications_icon.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_widget.dart';

// Vista principal del home de la aplicación
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userRol = context.watch<Globalcubit>().state.user?.role;
    // Provee el SideMenuCubit a los widgets hijos
    return BlocProvider(
      create: (_) => SideMenuCubit(userRol),
      child: BlocBuilder<SideMenuCubit, SideMenuState>(
        builder: (context, state) {
          // Obtiene el cubit para controlar el menú lateral y el PageView
          final sideMenuCubit = context.read<SideMenuCubit>();
          return Scaffold(
            // Barra superior de la aplicación
            appBar: AppBar(
              backgroundColor:
                  SchemaColors.primary, // Color de fondo personalizado
              leading: IconButton(
                // Botón para mostrar/ocultar el menú lateral
                onPressed: () => sideMenuCubit.toggleMenu(),
                icon: Icon(Icons.menu, color: SchemaColors.neutral),
              ),
              actions: [
                NotificationIcon()
              ],
            ),
            // Cuerpo principal de la vista
            body: Row(
              children: [
                // Menú lateral
                SideMenuWidget(),
                // Contenido principal, ocupa el espacio restante
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    // PageView para mostrar las diferentes páginas del menú
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(), // No permite swipe manual
                      controller: sideMenuCubit.pageController, // Controlador para cambiar de página desde el menú
                      children: sideMenuCubit.filteredViews
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
