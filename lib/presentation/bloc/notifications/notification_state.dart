part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final AppFailure? failure;

  const NotificationState({
    required this.status,
    this.notifications = const [],
    this.failure,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    AppFailure? failure,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, notifications, failure];
}
