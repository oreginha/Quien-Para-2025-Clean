// test/setup/test_dependency_setup.dart
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/repositories/application/application_repository.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/interfaces/application_repository_interface.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/save_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/match_plan_usecase.dart';
import 'package:quien_para/domain/usecases/application/apply_to_plan_usecase.dart';
import 'package:quien_para/domain/usecases/application/get_plan_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/get_user_applications_usecase.dart';
import 'package:quien_para/domain/usecases/application/update_application_status_usecase.dart';
import 'package:quien_para/domain/usecases/application/cancel_application_usecase.dart';
import 'package:quien_para/domain/usecases/chat/get_messages_usecase.dart';
import 'package:quien_para/domain/usecases/chat/send_message_usecase.dart';
import 'package:quien_para/domain/usecases/chat/create_conversation_usecase.dart';
import 'package:quien_para/domain/usecases/chat/get_user_conversations_usecase.dart';
import 'package:quien_para/domain/usecases/chat/mark_messages_as_read_usecase.dart';
import 'package:quien_para/domain/usecases/plan/delete_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_plans_usecase.dart';
import 'package:quien_para/domain/interfaces/notification_service_interface.dart';

// Mocks para los repositorios
class MockPlanRepository extends Mock implements PlanRepository {}

// Mock para ApplicationRepositoryInterface y ApplicationRepository
class MockApplicationRepository extends Mock
    implements ApplicationRepositoryInterface, ApplicationRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockNotificationService extends Mock
    implements NotificationServiceInterface {}

// Configura las dependencias para pruebas
Future<void> setupTestDependencies() async {
  final GetIt sl = GetIt.instance;

  // Si ya están registradas, no vuelvas a registrarlas
  if (sl.isRegistered<PlanRepository>()) {
    return;
  }

  // Limpiar el contenedor por seguridad
  await sl.reset();

  // Registrar mocks de repositorios
  sl.registerLazySingleton<PlanRepository>(() => MockPlanRepository());

  // Registrar el mock que implementa ambas interfaces
  final mockAppRepo = MockApplicationRepository();
  sl.registerLazySingleton<ApplicationRepositoryInterface>(() => mockAppRepo);
  sl.registerLazySingleton<ApplicationRepository>(() => mockAppRepo);

  sl.registerLazySingleton<ChatRepository>(() => MockChatRepository());
  sl.registerLazySingleton<NotificationServiceInterface>(
    () => MockNotificationService(),
  );

  // Registrar casos de uso de planes
  sl.registerLazySingleton<GetPlanByIdUseCase>(
    () => GetPlanByIdUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<CreatePlanUseCase>(
    () => CreatePlanUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<UpdatePlanUseCase>(
    () => UpdatePlanUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<SavePlanUseCase>(
    () => SavePlanUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<MatchPlanUseCase>(
    () => MatchPlanUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<DeletePlanUseCase>(
    () => DeletePlanUseCase(sl<PlanRepository>()),
  );
  sl.registerLazySingleton<GetPlansUseCase>(
    () => GetPlansUseCase(sl<PlanRepository>()),
  );

  // Registrar casos de uso de aplicaciones
  sl.registerLazySingleton<ApplyToPlanUseCase>(
    () => ApplyToPlanUseCase(sl<ApplicationRepositoryInterface>()),
  );
  sl.registerLazySingleton<GetPlanApplicationsUseCase>(
    () => GetPlanApplicationsUseCase(sl<ApplicationRepositoryInterface>()),
  );
  sl.registerLazySingleton<GetUserApplicationsUseCase>(
    () => GetUserApplicationsUseCase(sl<ApplicationRepositoryInterface>()),
  );
  sl.registerLazySingleton<UpdateApplicationStatusUseCase>(
    () => UpdateApplicationStatusUseCase(sl<ApplicationRepositoryInterface>()),
  );
  sl.registerLazySingleton<CancelApplicationUseCase>(
    () => CancelApplicationUseCase(sl<ApplicationRepositoryInterface>()),
  );
  sl.registerLazySingleton<SendApplicationNotificationUseCase>(
    () => SendApplicationNotificationUseCase(),
  );

  // Registrar casos de uso de chat
  sl.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<CreateConversationUseCase>(
    () => CreateConversationUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<GetUserConversationsUseCase>(
    () => GetUserConversationsUseCase(sl<ChatRepository>()),
  );
  sl.registerLazySingleton<MarkMessagesAsReadUseCase>(
    () => MarkMessagesAsReadUseCase(sl<ChatRepository>()),
  );
}

class SendApplicationNotificationUseCase {}
