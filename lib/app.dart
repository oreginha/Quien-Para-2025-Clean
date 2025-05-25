// app.dart (consolidado)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter/material.dart' as material show ThemeMode;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/routes/app_router_unified.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import '/core/utils/auth_debugger.dart';
import '/core/utils/memory_manager.dart';
import '/core/utils/performance_logger.dart';
import '/core/theme/app_theme.dart';
import '/core/theme/provider/theme_provider.dart';
import 'presentation/widgets/utils/connectivity_banner.dart';

// Alias para evitar confusiones
typedef MaterialThemeMode = material.ThemeMode;

// El navigatorKey sigue siendo útil para navegación imperativa en ciertos casos
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Función para convertir nuestro ThemeMode personalizado al ThemeMode de Flutter
  MaterialThemeMode _convertToFlutterThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return MaterialThemeMode.light;
      case ThemeMode.dark:
        return MaterialThemeMode.dark;
      case ThemeMode.system:
        return MaterialThemeMode.system;
    }
  }

  final Logger logger = Logger();
  final Stopwatch _frameStopwatch = Stopwatch();

  // Referencia al administrador de memoria
  late MemoryManager _memoryManager;

  // Router de la aplicación
  late final AppRouter appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (kDebugMode) {
      logger.d('MyApp: initState() llamado');
      PerformanceLogger.logInit('MyApp');
    }

    // Habilitar el debugger de autenticación en modo debug
    if (kDebugMode) {
      AuthDebugger.enable(true);
    }

    // Inicializar el router inmediatamente
    final AuthCubit authCubit = context.read<AuthCubit>();
    appRouter.initialize(authCubit);
    AuthDebugger.log('MyApp: Router configurado con AuthCubit');

    // Configurar servicios adicionales después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Obtener referencia al administrador de memoria
      _memoryManager = Provider.of<MemoryManager>(context, listen: false);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (kDebugMode) {
      PerformanceLogger.logDispose('MyApp');
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      logger.d('MyApp: Cambio de ciclo de vida - $state');
    }

    // Manejar especialmente el caso de estado inactivo (ventana emergente abierta)
    // para evitar problemas con COOP y ventanas emergentes
    if (state == AppLifecycleState.inactive) {
      // Cuando la app se vuelve inactiva (por ejemplo, cuando se abre una ventana de autenticación),
      // no realizamos limpieza agresiva que podría afectar el proceso de autenticación
      if (kDebugMode) {
        logger.d(
            'Detectada apertura de ventana emergente, pausando operaciones de limpieza');
      }
      return;
    }

    // Gestionar memoria según el ciclo de vida
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden: // Manejar el nuevo estado hidden
        // La app está en segundo plano o parcialmente oculta, liberar recursos
        if (mounted) {
          _memoryManager.performCleanup(
              aggressive: state == AppLifecycleState.detached);
        }
        break;
      case AppLifecycleState.resumed:
        // La app volvió a primer plano
        // Comentado temporalmente: Actualización del token FCM
        /*
        if (mounted) {
          final AuthCubit authCubit = context.read<AuthCubit>();
          if (authCubit.state.status == AuthStatus.authenticated) {
            final NotificationService notificationService =
                Provider.of<NotificationService>(context, listen: false);
            notificationService.updateFCMToken();
          }
        }
        */
        break;
      case AppLifecycleState
            .inactive: // Manejar explícitamente el estado inactive
        // La app está inactiva pero visible (por ejemplo, durante una llamada)
        // No es necesario realizar ninguna acción específica aquí
        break;
    }
  }

  @override
  void reassemble() {
    if (kDebugMode) {
      logger.d('MyApp: reassemble() llamado - Hot Reload/Restart');
    }
    super.reassemble();
  }

  @override
  Widget build(final BuildContext context) {
    // Registrar tiempo de construcción para optimización
    if (kDebugMode) {
      _frameStopwatch.reset();
      _frameStopwatch.start();
      logger.d('MyApp: Iniciando build()...');
    }

    // Acceder al ThemeProvider para determinar el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Convertir nuestro ThemeMode personalizado al ThemeMode de Flutter
    final flutterThemeMode =
        _convertToFlutterThemeMode(themeProvider.themeMode);

    // Obtener el AuthCubit desde el provider
    final authCubit = Provider.of<AuthCubit>(context, listen: false);

    final Widget app = Directionality(
      textDirection: TextDirection.ltr,
      child: ConnectivityBanner(
        child: MaterialApp.router(
          // Configuración del router usando el router inicializado
          routerConfig: appRouter.router,
          title: 'Quién Para...?',
          debugShowCheckedModeBanner: false,

          // Aplicar el tema apropiado según el modo de tema seleccionado
          theme: AppTheme(isDarkMode: false).getTheme(),
          darkTheme: AppTheme(isDarkMode: true).getTheme(),
          themeMode: flutterThemeMode,

          // Builder para proporcionar el ThemeProvider y AuthCubit a todos los widgets descendientes
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ThemeProvider>.value(
                  value: themeProvider,
                ),
                // Asegurarnos de que AuthCubit esté disponible en toda la aplicación
                BlocProvider<AuthCubit>.value(
                  value: authCubit,
                ),
              ],
              child: child!,
            );
          },
        ),
      ),
    );

    if (kDebugMode) {
      _frameStopwatch.stop();
      logger.d(
          'MyApp: build() completado en ${_frameStopwatch.elapsedMilliseconds}ms');
    }

    return app;
  }
}
