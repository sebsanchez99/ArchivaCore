// lib/presentation/widgets/notification/notification_icon.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/notification_model.dart';
import 'package:frontend/presentation/global/constants/menu_items.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_events.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_state.dart';
import 'package:frontend/presentation/widgets/menu/side_menu_cubit.dart';

part '../utils/utils.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon>  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (notifications, _, __, ___) {
            final unreadCount = notifications.where((n) => !n.readed).length;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: SchemaColors.neutral),
                    onPressed: () async => await _showNotificationMenu(context, notifications, unreadCount > 0),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 22,
                      top: 20,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          orElse: () => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.notifications, color: SchemaColors.neutral),
              onPressed: null,
            ),
          ),
        );
      },
    );
  }
}