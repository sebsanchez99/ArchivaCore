import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/notification_model.dart';
import 'package:frontend/domain/repositories/notification_repository.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_events.dart';
import 'package:frontend/presentation/pages/notification/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationState> {
  NotificationBloc(super.initialState, {
    required NotificationRepository notificationRepository
  }) : _notificationRepository = notificationRepository {
    on<InititalizeEvent>(_onInitialize);
    on<DeleteAllNotificationsEvent>(_onDeleteAllNotifications);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<MarkNotificationEvent>(_onMarkNotification);
  }

  final NotificationRepository _notificationRepository;

  Future<void> _onInitialize(InititalizeEvent event, Emitter<NotificationState> emit) async {
    state.maybeWhen(
      loading: () {},
      orElse: () => emit(NotificationState.loading()),
    );
    final result = await _notificationRepository.getNotifications();
    emit(
      result.when(
        right: (response) {
          final responseData = response.data as List<dynamic>;
          final List<NotificationModel> notifications = responseData.map((notification) => NotificationModel.fromJson(notification)).toList();
          return NotificationState.loaded(notifications: notifications);
        }, 
        left: (failure) => NotificationState.failed(failure),
      ),
    );    
  }

  Future<void> _onDeleteAllNotifications(DeleteAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationState.loading());
    final result = await _notificationRepository.deleteAllNotification();
    emit(
      result.when(
        right: (response) {
          add(NotificationEvents.initialize());
          return NotificationState.loaded(response: response);
        }, 
        left: (failure) => NotificationState.failed(failure),
      ),
    );
  }

  Future<void> _onDeleteNotification(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationState.loading());
    final result = await _notificationRepository.deleteNotification(event.notificationId);
    emit(
      result.when(
        right: (response) {
          add(NotificationEvents.initialize());
          return NotificationState.loaded(response: response);
        }, 
        left: (failure) => NotificationState.failed(failure),
      ),
    );
  }

  Future<void> _onMarkNotification(MarkNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationState.loading());
    final result = await _notificationRepository.markNotification(event.notificationId);
    emit(
      result.when(
        right: (response) {
          add(NotificationEvents.initialize());
          return NotificationState.loaded(response: response);
        }, 
        left: (failure) => NotificationState.failed(failure),
      ),
    );
  }


}