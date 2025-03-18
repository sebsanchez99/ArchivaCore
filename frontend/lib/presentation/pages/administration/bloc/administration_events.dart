import 'package:freezed_annotation/freezed_annotation.dart';

part 'administration_events.freezed.dart';

@freezed
class AdministrationEvents with _$AdministrationEvents {
  factory AdministrationEvents.initialize() = InitializeEvent;
  factory AdministrationEvents.filterUsers({
    required String username
  }) = FilterUsersEvent;
}
