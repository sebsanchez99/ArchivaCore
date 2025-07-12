import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/global/constants/menu_items.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_state.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_widget.dart';

// Vista principal del home de la aplicación
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provee el SideMenuCubit a los widgets hijos
    return BlocProvider(
      create: (_) => SideMenuCubit(),
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
                // Botón de notificaciones con menú emergente
                Builder(
                  builder:
                      (context) => IconButton(
                        onPressed: () async {
                          final RenderBox button =
                              context.findRenderObject() as RenderBox;
                          final RenderBox overlay =
                              Overlay.of(context).context.findRenderObject()
                                  as RenderBox;
                          final Offset position = button.localToGlobal(
                            Offset.zero,
                            ancestor: overlay,
                          );

                          await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              position.dx,
                              position.dy + button.size.height,
                              overlay.size.width -
                                  position.dx -
                                  button.size.width,
                              overlay.size.height -
                                  position.dy -
                                  button.size.height,
                            ),
                            items: [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.mail),
                                  title: Text('Notificación 1'),
                                  subtitle: Text('Detalle de la notificación'),
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.warning),
                                  title: Text('Notificación 2'),
                                  subtitle: Text('Otra notificación'),
                                ),
                              ),
                            ],
                          );
                        },
                        icon: Icon(
                          Icons.notifications,
                          color: SchemaColors.neutral,
                        ),
                        tooltip: 'Ver notificaciones',
                      ),
                ),
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
                      physics:
                          NeverScrollableScrollPhysics(), // No permite swipe manual
                      controller:
                          sideMenuCubit
                              .pageController, // Controlador para cambiar de página desde el menú
                      // Genera una lista de widgets a partir de menuItems
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
