import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/enums/notification_filter.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_events.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_state.dart';
import 'package:frontend/presentation/pages/notification/widget/custom_notification.dart';
import 'package:frontend/presentation/pages/notification/widget/empty_state_widget.dart';
import 'package:frontend/presentation/widgets/buttons/custom_button.dart';
import 'package:frontend/presentation/widgets/states/failure_state.dart';
import 'package:frontend/presentation/widgets/states/loading_state.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late NotificationBloc notificationBloc;
  @override
  void initState() {
    super.initState();
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
  }

  @override
  void dispose() {
    notificationBloc.add(MarkAllNotificationEvent());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
      final bloc = context.read<NotificationBloc>();
        return Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                  onPressed: () {
                    context.read<NotificationBloc>().add(
                      NotificationEvents.createNotification(
                        title: 'Nueva Notificación',
                        message: 'Esta es una notificación de prueba en tiempo real.',
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Crear Notificación'),
                  ),
                  IconButton(
                    tooltip: 'Eliminar todas las notificaciones',
                    icon: Icon(Icons.delete_sweep, color: SchemaColors.error, size: 30),
                    onPressed: () => bloc.add(DeleteAllNotificationsEvent()), 
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    message: 'Todos',
                    width: 30,
                    height: 15, 
                    color: SchemaColors.neutral,
                    textColor: SchemaColors.textPrimary,
                    onPressed: () => bloc.add(FilterEvent(filter: NotificationFilter.all()))
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    message: 'No leídas', 
                    width: 30,
                    height: 15, 
                    color: SchemaColors.neutral,
                    textColor: SchemaColors.textPrimary,
                    onPressed: () => bloc.add(FilterEvent(filter: NotificationFilter.unread()))
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: state.map(
                  loading: (_) => LoadingState(), 
                  loaded: (value) {
                    if (value.filteredNotifications.isEmpty && value.currentFilter == NotificationFilter.all()) {
                      return const EmptyStateWidget(
                        icon: Icons.notifications_none,
                        title: "No tienes notificaciones",
                        subtitle: "Aquí se mostrarán tus notificaciones importantes. Por ahora, todo está tranquilo.",
                      );
                    }

                    if (value.filteredNotifications.isEmpty && value.currentFilter == NotificationFilter.unread()) {
                      return const EmptyStateWidget(
                        icon: Icons.notifications_active,
                        title: "No tienes notificaciones sin leer",
                        subtitle: "¡Estás al día! Aquí se mostrarán las notificaciones nuevas.",
                      );
                    }
                    return ListView.builder(
                      itemCount: value.filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = value.filteredNotifications[index];
                        return CustomNotification(
                          title: notification.title, 
                          details: notification.message, 
                          date: notification.date, 
                          readed: notification.readed,
                          onDelete: () => bloc.add(DeleteNotificationEvent(notificationId: notification.id)),
                        );
                      },
                    );
                  }, 
                  failed: (value) => FailureState(
                    failure: value.failure,
                    onRetry: () => bloc.add(InititalizeEvent()),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
