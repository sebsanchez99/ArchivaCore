import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/notification_model.dart';
import 'package:frontend/domain/repositories/notification_repository.dart';
import 'package:frontend/presentation/enums/notification_filter.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_events.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  NotificationBloc(super.initialState, {
    required NotificationRepository notificationRepository
  }) : _notificationRepository = notificationRepository {
    on<InititalizeEvent>(_onInitialize);
    on<SilentInititalizeEvent>(_onSilentInitialize);
    on<DeleteAllNotificationsEvent>(_onDeleteAllNotifications);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<MarkNotificationEvent>(_onMarkNotification);
    on<MarkAllNotificationEvent>(_onMarkAllNotifications);
    on<CreateNotificationEvent>(_onCreateNotification);
    on<FilterEvent>(_onFilter);
  }

  final NotificationRepository _notificationRepository;

  Future<void> _onInitialize(InititalizeEvent event, Emitter<NotificationState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(NotificationState.loading()),
    );
    await _fetchNotifications(emit);   
  }

  Future<void> _onSilentInitialize(SilentInititalizeEvent event, Emitter<NotificationState> emit) async {
    await _fetchNotifications(emit);   
  }

  Future<void> _onDeleteAllNotifications(DeleteAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        final currentNotifications = List<NotificationModel>.from(value.notifications);
        emit(NotificationState.loaded(notifications: []));
        final result = await _notificationRepository.deleteAllNotification();
        result.when(
          right: (response) {
            if (!response.result) {
              emit(value.copyWith(notifications: currentNotifications, filteredNotifications: currentNotifications));
            } else {
              add(SilentInititalizeEvent());
            }
          }, 
          left: (failure) => NotificationState.failed(failure),
        );
      },
    );
  }

  Future<void> _onDeleteNotification(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    await state.mapOrNull(
      loaded: (value) async {
        final currentNotifications = List<NotificationModel>.from(value.notifications);
        final updatedNotifications = currentNotifications.where((n) => n.id != event.notificationId).toList();
        emit(value.copyWith(notifications: updatedNotifications));
        final result = await _notificationRepository.deleteNotification(event.notificationId);
        result.when(
          right: (response) {
            if (!response.result) {
              emit(value.copyWith(notifications: currentNotifications, filteredNotifications: currentNotifications));
            } else {
              add(SilentInititalizeEvent());
            }
          }, 
          left: (failure) => NotificationState.failed(failure),
        );
      },
    );
  }

  Future<void> _onMarkNotification(MarkNotificationEvent event, Emitter<NotificationState> emit) async {
    await state.maybeWhen(
      loaded: (notifications, _, __, ___) async {
        final currentNotifications = List<NotificationModel>.from(notifications);
        final updatedNotifications = currentNotifications.map((n) => n.copyWith(readed: n.id == event.notificationId ? true : n.readed)).toList();
        emit(NotificationState.loaded(notifications: updatedNotifications));
        final result = await _notificationRepository.markNotification(event.notificationId);
        result.when(
          right: (response) {
            if (!response.result) {
              emit(NotificationState.loaded(notifications: currentNotifications, filteredNotifications: currentNotifications));
            }
          }, 
          left: (failure) => emit(NotificationState.loaded(notifications: currentNotifications)),
        );
      },
      orElse: () { },
    );
  }

  Future<void> _onMarkAllNotifications(MarkAllNotificationEvent event, Emitter<NotificationState> emit) async {
    await state.maybeWhen(
      loaded: (notifications, _, __, ___) async {
        final currentNotifications = List<NotificationModel>.from(notifications);
        final updatedNotifications = currentNotifications.map((n) => n.copyWith(readed:true)).toList();
        emit(NotificationState.loaded(notifications: updatedNotifications));
        final result = await _notificationRepository.markAllNotification();
        result.when(
          right: (response) {
            if (!response.result) {
              emit(NotificationState.loaded(notifications: currentNotifications, filteredNotifications: currentNotifications));
            } else {
              add(SilentInititalizeEvent());
            }
          }, 
          left: (failure) => emit(NotificationState.loaded(notifications: currentNotifications, filteredNotifications: currentNotifications)),
        );
      },
      orElse: () { },
    );
  }

  Future<void> _onCreateNotification(CreateNotificationEvent event, Emitter<NotificationState> emit) async {
    final result = await _notificationRepository.createNotification(event.title, event.message);
    result.when(
      right: (response) => add(SilentInititalizeEvent()),
      left: (failure) => emit(NotificationState.failed(failure)),
    );
  }

  Future<void> _onFilter(FilterEvent event, Emitter<NotificationState> emit) async {
    state.mapOrNull(
      loaded: (value) {
        if (event.filter == NotificationFilter.unread()) {
          final unread = value.notifications.where((n) => !n.readed).toList();
          emit(value.copyWith(filteredNotifications: unread, currentFilter: NotificationFilter.unread()));
        } else {
          emit(value.copyWith(filteredNotifications: value.notifications, currentFilter: NotificationFilter.all()));
        }
      },
    );
  }

  Future<void> _fetchNotifications(Emitter<NotificationState> emit) async {
    final result = await _notificationRepository.getNotifications();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data as List<dynamic>;
          final List<NotificationModel> notifications = responseData.map((notification) => NotificationModel.fromJson(notification)).toList();
          return NotificationState.loaded(notifications: notifications, filteredNotifications: notifications);
        }, 
        left: (failure) => NotificationState.failed(failure),
      ),
    );
  }
}