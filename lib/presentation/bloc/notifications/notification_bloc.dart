import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/interfaces/notification_service_interface.dart';
import 'package:quien_para/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:quien_para/domain/usecases/notification/mark_notification_as_read_usecase.dart';

import '../../../domain/interfaces/notification_repository_interface.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final INotificationRepository _repository;
  final NotificationServiceInterface _notificationService;

  // Casos de uso
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  // Suscripción a notificaciones
  StreamSubscription? _notificationSubscription;

  NotificationBloc({
    required INotificationRepository repository,
    required NotificationServiceInterface notificationService,
  })  : _repository = repository,
        _notificationService = notificationService,
        _getNotificationsUseCase = GetNotificationsUseCase(repository),
        _markNotificationAsReadUseCase = MarkNotificationAsReadUseCase(
          repository,
        ),
        super(const NotificationState(status: NotificationStatus.initial)) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<InitializeNotificationsEvent>(_onInitializeNotifications);

    // Initialize notifications and setup real-time updates
    add(const InitializeNotificationsEvent());

    // Listen for real-time notification updates
    _notificationSubscription =
        _notificationService.onNotificationReceived.listen((
      notification,
    ) {
      // Cuando se recibe una notificación, recargar las notificaciones del usuario actual
      final userId = notification['userId'] as String?;
      if (userId != null) {
        add(LoadNotificationsEvent(userId: userId));
      }
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await _getNotificationsUseCase.execute(
      GetNotificationsParams(
        userId: event.userId,
        includeRead: event.includeRead,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: NotificationStatus.error, failure: failure),
      ),
      (notifications) => emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      ),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markNotificationAsReadUseCase.execute(
      event.notificationId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: NotificationStatus.error, failure: failure),
      ),
      (_) => add(LoadNotificationsEvent(userId: event.userId)),
    );
  }

  Future<void> _onInitializeNotifications(
    InitializeNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _repository.initialize();

    result.fold(
      (failure) => emit(
        state.copyWith(status: NotificationStatus.error, failure: failure),
      ),
      (_) => null,
    );
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
