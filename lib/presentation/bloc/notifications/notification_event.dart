part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class InitializeNotificationsEvent extends NotificationEvent {
  const InitializeNotificationsEvent();
}

class LoadNotificationsEvent extends NotificationEvent {
  final String userId;
  final int? limit;
  final bool includeRead;

  const LoadNotificationsEvent({
    required this.userId,
    this.limit,
    this.includeRead = false,
  });

  @override
  List<Object> get props => [userId, includeRead];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;
  final String userId;

  const MarkNotificationAsReadEvent({
    required this.notificationId,
    required this.userId,
  });

  @override
  List<Object> get props => [notificationId, userId];
}
