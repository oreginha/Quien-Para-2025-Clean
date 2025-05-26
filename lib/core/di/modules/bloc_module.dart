import 'package:quien_para/core/di/modules/usecase_module.dart'; // lib/core/di/modules/bloc_module.dart

import 'package:get_it/get_it.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/chat/chat_bloc.dart';
import 'package:quien_para/presentation/bloc/feed/feed_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/profile/user_profile_bloc.dart';
import 'package:quien_para/presentation/bloc/matching/matching_bloc.dart';
import 'package:quien_para/core/di/modules/di_module.dart';
import 'package:quien_para/domain/interfaces/application_repository_interface.dart';
import 'package:quien_para/domain/interfaces/notification_service_interface.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/repositories/user/user_repository_interface.dart';
import 'package:quien_para/domain/usecases/application/apply_to_plan_usecase.dart';
import 'package:quien_para/domain/usecases/application/cancel_application_usecase.dart';
import 'package:quien_para/domain/usecases/application/get_plan_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/get_user_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/update_application_status_usecase.dart';

// Casos de uso base
import 'package:quien_para/domain/usecases/plan/match_plan_usecase.dart';

// Casos de uso de plan
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart'
    as plan;
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/delete_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_plans_usecase.dart';
import 'package:quien_para/domain/usecases/plan/save_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_other_users_plans_usecase.dart';

// Casos de uso de aplicación
import 'package:quien_para/domain/usecases/application/send_application_notification_usecase.dart';

// Casos de uso de chat
import 'package:quien_para/domain/usecases/chat/get_messages_usecase.dart';
import 'package:quien_para/domain/usecases/chat/send_message_usecase.dart';
import 'package:quien_para/domain/usecases/chat/create_conversation_usecase.dart';
import 'package:quien_para/domain/usecases/chat/get_user_conversations_usecase.dart';
import 'package:quien_para/domain/usecases/chat/mark_messages_as_read_usecase.dart';

import 'package:quien_para/core/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Módulo que registra todos los BLoCs y Cubits de la aplicación.
class BlocModule implements DIModule {
  @override
  Future<void> register(GetIt container) async {
    logger.d('Registrando módulo de BLoCs y Cubits');

    // Verificar dependencias de forma resiliente
    await _ensureDependenciesRegistered(container);

    // Registrar AuthCubit de forma segura
    if (!container.isRegistered<AuthCubit>()) {
      try {
        container.registerLazySingleton<AuthCubit>(
          () => AuthCubit(
            container<AuthRepository>(),
            container<SharedPreferences>(),
          ),
        );
        logger.d('AuthCubit registrado correctamente');
      } catch (e) {
        logger.w('Error registrando AuthCubit: ${e.toString().split('\n')[0]}');
      }
    }

    // Registrar UserProfileBloc de forma segura
    if (!container.isRegistered<UserProfileBloc>()) {
      try {
        container.registerLazySingleton<UserProfileBloc>(
          () => UserProfileBloc(userRepository: container<IUserRepository>()),
        );
        logger.d('UserProfileBloc registrado correctamente');
      } catch (e) {
        logger.w(
          'Error registrando UserProfileBloc: ${e.toString().split('\n')[0]}',
        );
      }
    }

    // Registrar PlanBloc de forma segura
    if (!container.isRegistered<PlanBloc>()) {
      try {
        if (_areAvailable(container, [
          GetPlanByIdUseCase,
          plan.CreatePlanUseCase,
          UpdatePlanUseCase,
          SavePlanUseCase,
          PlanRepository,
          GetOtherUserPlansUseCase,
        ])) {
          container.registerLazySingleton<PlanBloc>(
            () => PlanBloc(
              getPlanByIdUseCase: container<GetPlanByIdUseCase>(),
              createPlanUseCase: container<plan.CreatePlanUseCase>(),
              updatePlanUseCase: container<UpdatePlanUseCase>(),
              savePlanUseCase: container<SavePlanUseCase>(),
              //otherUsersPlansUseCase: container<GetOtherUserPlansUseCase>(),
              planRepository: container<PlanRepository>(),
            ),
          );
          logger.d('PlanBloc registrado correctamente');
        } else {
          logger.w('No se pudo registrar PlanBloc - faltan dependencias');
        }
      } catch (e) {
        logger.w('Error registrando PlanBloc: ${e.toString().split('\n')[0]}');
      }
    }

    // Registrar MatchingBloc de forma segura
    if (!container.isRegistered<MatchingBloc>()) {
      try {
        if (container.isRegistered<ApplicationRepositoryInterface>() &&
            container.isRegistered<NotificationServiceInterface>()) {
          final applicationRepo = container<ApplicationRepositoryInterface>();

          container.registerLazySingleton<MatchingBloc>(
            () => MatchingBloc(
              ApplyToPlanUseCase(applicationRepo),
              GetPlanApplicationsUseCase(applicationRepo),
              GetUserApplicationsUseCase(applicationRepo),
              UpdateApplicationStatusUseCase(applicationRepo),
              CancelApplicationUseCase(applicationRepo),
              container<SendApplicationNotificationUseCase>(),
            ),
          );
          logger.d('MatchingBloc registrado correctamente');
        } else {
          logger.w('No se pudo registrar MatchingBloc - faltan repositorios');
        }
      } catch (e) {
        logger.w(
          'Error registrando MatchingBloc: ${e.toString().split('\n')[0]}',
        );
      }
    }

    // Registrar ChatBloc de forma segura
    if (!container.isRegistered<ChatBloc>()) {
      try {
        if (_areAvailable(container, [
          GetMessagesUseCase,
          SendMessageUseCase,
          CreateConversationUseCase,
          GetUserConversationsUseCase,
          MarkMessagesAsReadUseCase,
        ])) {
          container.registerLazySingleton<ChatBloc>(
            () => ChatBloc.withUseCases(
              getMessagesUseCase: container<GetMessagesUseCase>(),
              sendMessageUseCase: container<SendMessageUseCase>(),
              createConversationUseCase: container<CreateConversationUseCase>(),
              getUserConversationsUseCase:
                  container<GetUserConversationsUseCase>(),
              markMessagesAsReadUseCase: container<MarkMessagesAsReadUseCase>(),
            ),
          );
          logger.d('ChatBloc registrado correctamente');
        } else {
          logger.w('No se pudo registrar ChatBloc - faltan dependencias');
        }
      } catch (e) {
        logger.w('Error registrando ChatBloc: ${e.toString().split('\n')[0]}');
      }
    }

    // Registrar FeedBloc de forma segura
    if (!container.isRegistered<FeedBloc>()) {
      try {
        if (_areAvailable(container, [
          GetPlansUseCase,
          MatchPlanUseCase,
          CreatePlanUseCase,
          DeletePlanUseCase,
        ])) {
          container.registerLazySingleton<FeedBloc>(
            () => FeedBloc(
              container<GetPlansUseCase>(),
              container<MatchPlanUseCase>(),
              container<CreatePlanUseCase>(),
              container<DeletePlanUseCase>(),
            ),
          );
          logger.d('FeedBloc registrado correctamente');
        } else {
          logger.w('No se pudo registrar FeedBloc - faltan dependencias');
        }
      } catch (e) {
        logger.w('Error registrando FeedBloc: ${e.toString().split('\n')[0]}');
      }
    }

    logger.d('Módulo de BLoCs registrado correctamente');
  }

  /// Helper para verificar si todas las dependencias están disponibles
  bool _areAvailable(GetIt container, List<Type> types) {
    try {
      for (final type in types) {
        // Intento buscar directamente
        container.get(type: type);
      }
      return true;
    } catch (e) {
      return false; // Al menos una dependencia no está disponible
    }
  }

  /// Método simplificado para verificar dependencias esenciales para BLoCs
  Future<void> _ensureDependenciesRegistered(GetIt container) async {
    logger.d('Verificando dependencias mínimas para BLoCs');

    // Lista mínima de casos de uso esenciales - solo los que realmente usamos
    [
      // Para PlanBloc
      GetPlanByIdUseCase,
      plan.CreatePlanUseCase,
      UpdatePlanUseCase,
      SavePlanUseCase,
      // Para FeedBloc
      GetPlansUseCase,
      MatchPlanUseCase,
      DeletePlanUseCase,
      // Para ChatBloc
      GetMessagesUseCase,
      SendMessageUseCase,
      CreateConversationUseCase,
      GetUserConversationsUseCase,
      MarkMessagesAsReadUseCase,
    ];

    // Intentamos registrar de manera resiliente los casos de uso
    // El objetivo es permitir que la aplicación inicie incluso si faltan algunas dependencias
    try {
      // Verificar disponibilidad de repositorios críticos
      if (!container.isRegistered<PlanRepository>() ||
          !container.isRegistered<ApplicationRepositoryInterface>()) {
        logger.w('Repositorios críticos no disponibles - BLoCs pueden fallar');
      }

      // Si UseCaseModule está disponible, intentamos registrarlo de nuevo
      try {
        final useCaseModule = UseCaseModule();
        await useCaseModule.register(container);
        logger.d('UseCaseModule registrado en verificación');
      } catch (e) {
        logger.d(
          'No se pudo registrar UseCaseModule: ${e.toString().split('\n')[0]}',
        );
      }

      // No fallamos catastróficamente para permitir que la app inicie
      // Registrar BLoCs individualmente manejará los casos de uso faltantes
    } catch (e) {
      logger.w(
        'Error en verificación de dependencias: ${e.toString().split('\n')[0]}',
      );
      // Continuamos a pesar del error
    }
  }

  @override
  Future<void> dispose(GetIt container) async {
    logger.d('Liberando recursos de BLoCs');

    if (container.isRegistered<PlanBloc>()) {
      await container<PlanBloc>().close();
    }

    if (container.isRegistered<FeedBloc>()) {
      await container<FeedBloc>().close();
    }

    if (container.isRegistered<MatchingBloc>()) {
      await container<MatchingBloc>().close();
    }

    if (container.isRegistered<ChatBloc>()) {
      await container<ChatBloc>().close();
    }

    if (container.isRegistered<UserProfileBloc>()) {
      await container<UserProfileBloc>().close();
    }

    if (container.isRegistered<AuthCubit>()) {
      await container<AuthCubit>().close();
    }

    logger.d('Recursos de BLoCs liberados correctamente');
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    logger.d('Registrando dependencias de prueba para BLoCs');

    // Asegurarse de que se registren los mocks de repositorios primero
    if (!container.isRegistered<AuthRepository>()) {
      throw StateError(
        'Los mocks de repositorios deben registrarse antes de BlocModule.registerTestDependencies',
      );
    }

    // Registrar BLoCs con dependencias mock
    await register(container);

    logger.d('Dependencias de prueba para BLoCs registradas correctamente');
  }
}
