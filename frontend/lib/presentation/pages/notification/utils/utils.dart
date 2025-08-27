part of '../view/notifications_icon.dart';

Future<void> _showNotificationMenu(
  BuildContext context,
  List<NotificationModel> notifications,
  bool hasUnread,
) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);
  const double menuOffset = 150.0;

  final unreadNotifications = notifications.where((n) => !n.readed).toList();

  await showMenu(
    color: SchemaColors.background,
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + button.size.height,
      overlay.size.width - position.dx - button.size.width - menuOffset,
      overlay.size.height - position.dy - button.size.height,
    ),
    menuPadding: EdgeInsets.all(8),
    items: <PopupMenuEntry<dynamic>>[
      if (unreadNotifications.isEmpty)
        const PopupMenuItem(
          enabled: false,
          child: Text('No hay notificaciones sin leer'),
        ),
      ...unreadNotifications.map((notification) {
        return PopupMenuItem(
          mouseCursor: SystemMouseCursors.click,
          // Quitamos el valor 'value' y la lógica de navegación
          // El menú ya no necesita saber qué notificación fue seleccionada
          child: Row(
            children: [
              Icon(Icons.mark_email_unread, color: SchemaColors.secondary),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      notification.message,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      if (notifications.isNotEmpty) const PopupMenuDivider(),
      if (notifications.isNotEmpty)
        const PopupMenuItem(
          mouseCursor: SystemMouseCursors.click,
          value: 'view_all',
          child: Row(
            children: [
              Icon(Icons.list),
              SizedBox(width: 8),
              Text('Ver todas las notificaciones'),
            ],
          ),
        ),
    ],
  ).then((selected) {
    if (context.mounted) {
      if (hasUnread) {
        context.read<NotificationBloc>().add(
          NotificationEvents.markAllNotifications(),
        );
      }
      if (selected == 'view_all') {
        final sideMenuCubit = context.read<SideMenuCubit>();
        final notificationIndex = menuItems.keys.firstWhere(
          (k) => menuItems[k]!['title'] == 'Notificaciones',
        );
        sideMenuCubit.selectIndex(notificationIndex);
      }
    }
  });
}
