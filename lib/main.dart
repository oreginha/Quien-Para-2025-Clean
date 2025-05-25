// lib/main.dart
// Punto de entrada optimizado de la aplicación - arranque rápido

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importaciones específicas del proyecto
import 'core/config/firebase_options.dart';
import 'core/di/progressive_injection.dart';
import 'core/theme/provider/theme_provider.dart';
import 'core/utils/memory_manager.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/plan/plan_bloc.dart';
import 'presentation/bloc/feed/feed_bloc.dart';
import 'presentation/bloc/chat/simple_chat_bloc.dart';
import 'domain/repositories/plan/plan_repository.dart';

// Casos de uso esenciales
import 'domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'domain/usecases/plan/get_plans_usecase.dart';
import 'domain/usecases/plan/match_plan_usecase.dart';
import 'domain/usecases/plan/create_plan_usecase.dart';
import 'domain/usecases/plan/update_plan_usecase.dart';
import 'domain/usecases/plan/save_plan_usecase.dart';
import 'domain/usecases/plan/delete_plan_usecase.dart';

import 'data/repositories/auth/auth_repository_impl.dart';

// Aplicación principal
import 'app.dart';

/// Manejador de mensajes en segundo plano para Firebase Cloud Messaging
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('📱 Mensaje en segundo plano: ${message.notification?.title}');
  }
}

/// Punto de entrada optimizado - UNA SOLA llamada a runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print('🚀 Iniciando aplicación OPTIMIZADA');
  }

  try {
    // Inicialización mínima y crítica
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final messaging = FirebaseMessaging.instance;
    final analytics = FirebaseAnalytics.instance;
    final sharedPreferences = await SharedPreferences.getInstance();

    // Configurar Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inicializar servicios básicos de forma lazy
    await ProgressiveInjection.initializeServices();
    await ProgressiveInjection.initializeRepositories();

    // Solo casos de uso esenciales para el arranque (sin los problemáticos)
    final essentialUseCases = [
      'CreatePlanUseCase',
      'GetPlanByIdUseCase',
      'UpdatePlanUseCase',
      'SavePlanUseCase',
      'GetPlansUseCase',
      'MatchPlanUseCase',
      'DeletePlanUseCase',
      'ApplyToPlanUseCase',
      'GetPlanApplicationsUseCase',
      'GetUserApplicationsUseCase',
      'UpdateApplicationStatusUseCase',
      'CancelApplicationUseCase',
      // Nuevos casos de uso de búsqueda
      'SearchPlansUseCase',
      'FilterPlansByLocationUseCase',
      'FilterPlansByDateUseCase',
      'FilterPlansByCategoryUseCase',
      // Nuevos casos de uso de seguridad
      'CreateReportUseCase',
      'GetPendingReportsUseCase',
      'GetReportsByUserUseCase',
      'UpdateReportStatusUseCase',
      // Se omite deliberadamente: 'SendApplicationNotificationUseCase'
      // Se omite por ahora: 'GetOtherUsersPlansUseCase'
    ];
    await ProgressiveInjection.initializeMultipleUseCases(essentialUseCases);

    // AuthRepository simple
    final authRepository = AuthRepositoryImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
      firestore: firestore,
    );

    // AuthCubit
    final authCubit = AuthCubit(authRepository, sharedPreferences);

    // BLoCs esenciales
    late PlanBloc planBloc;
    try {
      planBloc = PlanBloc(
        getPlanByIdUseCase: ProgressiveInjection.sl
            .get<GetPlanByIdUseCase>(instanceName: 'GetPlanByIdUseCase'),
        createPlanUseCase: ProgressiveInjection.sl
            .get<CreatePlanUseCase>(instanceName: 'CreatePlanUseCase'),
        updatePlanUseCase: ProgressiveInjection.sl
            .get<UpdatePlanUseCase>(instanceName: 'UpdatePlanUseCase'),
        savePlanUseCase: ProgressiveInjection.sl
            .get<SavePlanUseCase>(instanceName: 'SavePlanUseCase'),
        //otherUsersPlansUseCase: null, // Omitido temporalmente para estabilidad
        planRepository: ProgressiveInjection.sl
            .get<PlanRepository>(instanceName: 'PlanRepository'),
      );
      if (kDebugMode) {
        print('✅ PlanBloc inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando PlanBloc: $e');
        // Imprimir estado de todos los casos de uso registrados
        final status = ProgressiveInjection.getInitializationStatus();
        print('📊 Estado de inicialización: $status');
      }
      rethrow;
    }

    final feedBloc = FeedBloc(
      ProgressiveInjection.sl
          .get<GetPlansUseCase>(instanceName: 'GetPlansUseCase'),
      ProgressiveInjection.sl
          .get<MatchPlanUseCase>(instanceName: 'MatchPlanUseCase'),
      ProgressiveInjection.sl
          .get<CreatePlanUseCase>(instanceName: 'CreatePlanUseCase'),
      ProgressiveInjection.sl
          .get<DeletePlanUseCase>(instanceName: 'DeletePlanUseCase'),
    );

    // SimpleChatBloc
    final simpleChatBloc = ProgressiveInjection.sl
        .get<SimpleChatBloc>(instanceName: 'SimpleChatBloc');

    // Verificar auth estado
    authCubit.checkAuthStatus();

    // LANZAR APP - UNA SOLA VEZ
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<PlanBloc>.value(value: planBloc),
          BlocProvider<FeedBloc>.value(value: feedBloc),
          BlocProvider<SimpleChatBloc>.value(value: simpleChatBloc),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider()),
            Provider<MemoryManager>(create: (_) => MemoryManager()),
            Provider<FirebaseAnalyticsObserver>.value(
              value: FirebaseAnalyticsObserver(analytics: analytics),
            ),
            Provider<FirebaseFirestore>.value(value: firestore),
            Provider<FirebaseStorage>.value(value: storage),
            Provider<FirebaseMessaging>.value(value: messaging),
            Provider<FirebaseAuth>.value(value: firebaseAuth),
            Provider<GoogleSignIn>.value(value: googleSignIn),
            Provider<SharedPreferences>.value(value: sharedPreferences),
          ],
          child: const MyApp(),
        ),
      ),
    );

    if (kDebugMode) {
      print('✅ Aplicación iniciada correctamente');
    }
  } catch (error, stack) {
    if (kDebugMode) {
      print('❌ Error grave: $error');
      print('Stack trace: $stack');
    }

    // Pantalla de error simple
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text('ERROR DE INICIALIZACIÓN',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(error.toString(),
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
