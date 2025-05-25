import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/presentation/screens/chat/chat_screen_responsive.dart';
import '../bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/routes/redirect_handler.dart';
import 'package:quien_para/presentation/screens/auth/auth_wrapper.dart';
import 'package:quien_para/presentation/screens/example/responsive_example_screen.dart';
import 'package:quien_para/presentation/screens/profile/edit_profile_screen_responsive.dart';
import 'package:quien_para/presentation/screens/create_proposal/onboarding_plan_flow_responsive.dart';
import 'package:quien_para/presentation/screens/my_applications/my_applications_screen.dart';
import 'package:quien_para/presentation/screens/theme_showcase/theme_showcase_screen.dart';
import 'package:quien_para/presentation/screens/Feed_Otros_Usuarios/feed_otros_usuarios.dart';
import '../bloc/applications_management/applications_management_provider.dart';
// Make sure that the FeedOtrosUsuarios widget is defined and exported in the above file.
// If the widget is named differently (e.g., FeedOtrosUsuariosScreen), update all usages accordingly.
import '../screens/Otras_Propuestas/feed_otras_propuestas.dart';
import '../screens/otras_propuestas/Detalles_Propuesta_Otros.dart';
import '../screens/Aplicantes/applications_management_screen.dart';
import '../screens/Aplicantes/applicants_list_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/chat/conversations_list_screen.dart';
import '../screens/search/search_filters_screen.dart';
import '../screens/Login/login_screen.dart';
import '../screens/user_onboarding/user_onboarding_screen.dart';
import '../screens/phone_auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/Mis_Propuestas/mi_plan_detalle.dart';
import '../screens/Seetings/settings_screen.dart';
import '../screens/profile/user_feed_screen.dart' as user_feed;
import '../screens/Mis_Propuestas/feed_mis_planes.dart';
import '../../core/utils/auth_debugger.dart';

// Tipos de transiciones disponibles para las páginas
enum PageTransitionType {
  fade, // Transición con desvanecimiento
  slide, // Transición deslizante desde la derecha
  slideUp, // Transición deslizante desde abajo
  scale, // Transición con escalado
  none // Sin transición
}

/// Router principal de la aplicación utilizando GoRouter
/// Router unificado que combina las funcionalidades de diferentes implementaciones previas
class AppRouter {
  // Singleton instance
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  // Logger for debugging
  final Logger logger = Logger();

  // Router instance
  late final GoRouter router;

  // Estado de redirecciones para prevenir bucles
  static const _redirectCooldown = Duration(milliseconds: 500);

  // Authentication cubit
  AuthCubit? _authCubit;

  // Estado de redirecciones para prevenir bucles
  String? _lastRedirectPath;
  DateTime? _lastRedirectTime;

  // Método para inicializar el router
  void initialize(AuthCubit authCubit) {
    _authCubit = authCubit;
    _setupRedirectHandler(authCubit);

    router = _getRouter();

    if (kDebugMode) {
      print('🚀 [Router] Inicializado con éxito');
    }
  }

  // Rutas constantes
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String themeShowcase = '/theme-showcase';
  static const String notifications = '/notifications';
  static const String phoneAuth = '/phone-auth';
  static const String userOnboarding = '/user-onboarding';
  static const String proposalsScreen = '/proposalsScreen';
  static const String planes = '/planes';
  static const String mainPlan = '/mainPlan';
  static const String createProposal = '/create-proposal';
  static const String proposalDetail = '/proposal-detail';
  static const String myPlanDetail = '/myPlanDetail/:planId';
  static const String otherProposalDetail = '/otherProposalDetail/:planId';
  static const String chat = '/chat/:chatId';
  static const String conversationsList = '/conversations';
  static const String otherUserProfile = '/other-user-profile/:userId';
  static const String applicationsManagement =
      '/applications-management/:planId';
  static const String screenMigrationExample = '/screen-migration-example';
  static const String responsiveExample = '/responsive-example';
  static const String searchFilters = '/search-filters';
  static const String myApplications = '/my-applications';
  static const String feedOtrosUsuarios = '/feed-otros-usuarios/:userId';
  static const String applicantsList = '/applicants-list/:planId';

  // Importar el manejador de redirecciones separado
  final RedirectHandler _redirectHandler = RedirectHandler();

  // Método para configurar el AuthCubit en el redirectHandler
  void _setupRedirectHandler(AuthCubit authCubit) {
    _redirectHandler.setAuthCubit(authCubit);
  } // ignore_for_file: unnecessary_null_comparison

  // Método para obtener el router de manera segura
  GoRouter _getRouter() {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: kDebugMode,
      observers: [GoRouterObserver(logger)],

      // Página para rutas desconocidas
      errorBuilder: (context, state) {
        if (kDebugMode) {
          print('🚨 [Router] Error de navegación: ${state.error}');
          print('🚨 [Router] Ruta no encontrada: ${state.uri.path}');
        }

        return UnknownRouteScreen(
          routePath: state.uri.path,
          errorMessage: state.error?.toString(),
        );
      },

      // Redirección basada en el estado de autenticación
      redirect: (context, state) {
        final String currentPath = state.fullPath ?? '';
        return _redirectHandler.handleRedirect(context, currentPath,
            skipSpecialPaths: true);
      },

      // Rutas de la aplicación
      routes: [
        // Root / Auth Wrapper
        GoRoute(
          path: root,
          builder: (context, state) => const AuthWrapper(),
        ),

        // Home
        GoRoute(
          path: home,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        // Login
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),

        // Profile
        GoRoute(
          path: profile,
          builder: (context, state) => const user_feed.UserFeedScreen(),
        ),

        // Edit Profile
        GoRoute(
          path: editProfile,
          builder: (context, state) => const EditProfileScreenResponsive(),
        ),

        // Settings
        GoRoute(
          path: settings,
          builder: (context, state) => const SettingsScreen(),
        ),

        // Theme Showcase
        GoRoute(
          path: themeShowcase,
          builder: (context, state) => const ThemeShowcaseScreen(),
        ),

        // Notifications
        GoRoute(
          path: notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),

        // Phone Auth
        GoRoute(
          path: phoneAuth,
          builder: (context, state) => const PhoneAuthScreen(),
        ),

        // User Onboarding
        GoRoute(
          path: userOnboarding,
          builder: (context, state) => const UserOnboardingScreen(),
        ),

        // Proposals
        GoRoute(
          path: proposalsScreen,
          builder: (context, state) => const FeedPropuestas(),
        ),

        // Planes
        GoRoute(
          path: planes,
          builder: (context, state) =>
              const FeedMisPlanes(title: 'Quien para?'),
        ),

        // Main Plan
        GoRoute(
          path: mainPlan,
          builder: (context, state) =>
              const FeedMisPlanes(title: "Quien para?"),
        ),

        // Create Proposal
        GoRoute(
          path: createProposal,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return OnboardingPlanFlowResponsive(
              planId: extra['planId'] as String?,
              planData: extra['planData'] as Map<String, dynamic>?,
              isEditing: extra['isEditing'] as bool? ?? false,
            );
          },
        ),

        // Proposal Detail
        GoRoute(
          path: proposalDetail,
          builder: (context, state) {
            // Redirigir a feed de planes ya que PlanBloc individual no está disponible
            return const FeedMisPlanes(title: "Quien para?");
          },
        ),

        // Generic Plan Detail
        GoRoute(
          path: '/plan/:planId',
          builder: (context, state) {
            final String planId = state.pathParameters['planId'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final bool isCreator = extra['isCreator'] as bool? ?? false;

            if (isCreator) {
              return MyPlanDetailScreen(
                planId: planId,
                isCreator: isCreator,
              );
            } else {
              // No usar ChatBloc ya que no está disponible
              return DetallesPropuestaOtros(
                planId: planId,
                isCreator: isCreator,
              );
            }
          },
        ),

        // My Plan Detail
        GoRoute(
          path: myPlanDetail,
          builder: (context, state) {
            final String planId = state.pathParameters['planId'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final bool isCreator = extra['isCreator'] as bool? ?? false;
            return MyPlanDetailScreen(
              planId: planId,
              isCreator: isCreator,
            );
          },
        ),

        // Other Proposal Detail
        GoRoute(
          path: otherProposalDetail,
          builder: (context, state) {
            final String planId = state.pathParameters['planId'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final bool isCreator = extra['isCreator'] as bool? ?? false;

            // No usar ChatBloc ya que no está disponible
            return DetallesPropuestaOtros(
              planId: planId,
              isCreator: isCreator,
            );
          },
        ),

        // Chat
        GoRoute(
          path: chat,
          builder: (context, state) {
            final String chatId = state.pathParameters['chatId'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final String otherUserName =
                extra['otherUserName'] as String? ?? '';
            final String? otherUserPhoto = extra['otherUserPhoto'] as String?;

            return ChatScreenResponsive(
              chatId: chatId,
              otherUserName: otherUserName,
              otherUserPhoto: otherUserPhoto,
              conversationId: '',
              receiverId: '',
              receiverName: '',
            );
          },
        ),

        // Conversations List
        GoRoute(
          path: conversationsList,
          builder: (context, state) => const ConversationsListScreen(),
        ),

        // Other User Profile
        GoRoute(
          path: otherUserProfile,
          builder: (context, state) {
            final String userId = state.pathParameters['userId'] ?? '';
            return FeedOtroUsuario(userId: userId);
          },
        ),

        // Applications Management
        GoRoute(
          path: applicationsManagement,
          builder: (context, state) {
            final String planId = state.pathParameters['planId'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final String planTitle = extra['planTitle'] as String? ?? '';

            return ApplicationsManagementProvider(
              child: ApplicationsManagementScreen(
                planId: planId,
                planTitle: planTitle,
              ),
            );
          },
        ),
        // Responsive Example
        GoRoute(
          path: responsiveExample,
          builder: (context, state) => const ResponsiveExampleScreen(),
        ),

        // Search Filters
        GoRoute(
          path: searchFilters,
          builder: (context, state) => const SearchFiltersScreen(),
        ),

        // My Applications
        GoRoute(
          path: myApplications,
          builder: (context, state) => const MyApplicationsScreen(),
        ),

        // Feed Otros Usuarios
        GoRoute(
          path: feedOtrosUsuarios,
          builder: (context, state) {
            final String userId = state.pathParameters['userId'] ?? '';
            return FeedOtroUsuario(userId: userId);
          },
        ),

        // Applicants List
        GoRoute(
          path: applicantsList,
          builder: (context, state) {
            final String planId = state.pathParameters['planId'] ?? '';
            return ApplicantsListScreen(planId: planId);
          },
        ),
      ],
    );
  }

  // Mapa de índices de navegación para el BottomNavBar
  final Map<String, int> navigationIndices = {
    conversationsList: 0, // Mensajes
    proposalsScreen: 1, // Propuestas
    home: 2, // Home
    profile: 3, // Perfil
    notifications: 4, // Notificaciones
  };

  // Obtener índice para el BottomNavBar
  int getNavigationIndex(String route) {
    // Primero, intentar coincidencia exacta
    if (navigationIndices.containsKey(route)) {
      return navigationIndices[route]!;
    }

    // Si no hay coincidencia exacta, buscar ruta parcial
    for (final entry in navigationIndices.entries) {
      if (route.startsWith(entry.key) && entry.key != '/') {
        return entry.value;
      }
    }

    // Por defecto, devolver home
    return navigationIndices[home]!;
  }

  // Configurar el router con el AuthCubit
  void setAuthCubit(AuthCubit authCubit) {
    _authCubit = authCubit;
    _redirectHandler.setAuthCubit(authCubit);
    // Registrar que se ha configurado el AuthCubit correctamente
    AuthDebugger.log('AuthCubit configurado correctamente en AppRouter');
  }

  // Métodos de navegación de conveniencia para mantener compatibilidad con el código existente

  // Navegar a una ruta por nombre
  void goNamed(
    BuildContext context,
    String name, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) {
    context.pushNamed(
      name,
      pathParameters: params ?? {},
      queryParameters: queryParams ?? {},
      extra: extra,
    );
  }

  // Navegar a una ruta directamente
  void go(BuildContext context, String path, {Object? extra}) {
    context.push(path, extra: extra);
  }

  // Volver a la pantalla anterior with mejorada
  void goBackWithAnimation(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Usar directamente el método go de GoRouter en lugar de la extensión
      GoRouter.of(context).go(home, extra: {'animated': true});
    }
  }

  // Mantener el método original por compatibilidad con código existente
  void goBack(BuildContext context) {
    goBackWithAnimation(context);
  }

  // Método más consistente para ir a una ruta
  void goToRoute(BuildContext context, String route, {Object? extra}) {
    // Verificar si la ruta es compatible con la estructura del router
    if (route.startsWith('/plan/')) {
      // Si es una ruta de plan, extraer el ID y usar la ruta correspondiente
      final String planId = route.substring('/plan/'.length);
      if (kDebugMode) {
        print('Navegando a plan con ID: $planId');
      }

      // Evaluar qué tipo de plan es (propio u otro) basado en extra
      final Map<String, dynamic> extraMap =
          extra as Map<String, dynamic>? ?? {};
      final bool isCreator = extraMap['isCreator'] as bool? ?? false;

      if (isCreator) {
        // Si es el creador, usar la ruta de planes propios
        context.push('/myPlanDetail/$planId', extra: extra);
      } else {
        // Si no es el creador, usar la ruta de propuestas de otros
        context.push('/otherProposalDetail/$planId', extra: extra);
      }
    } else {
      // Para todas las demás rutas, usar el método normal
      GoRouter.of(context).go(route, extra: extra);
    }
  }

  // Navegar a ThemeShowcase
  void goToThemeShowcase(BuildContext context) {
    context.push(themeShowcase);
  }

  // Navegar a OtherUserProfile
  void goToOtherUserProfile(BuildContext context, String userId) {
    context.push('/other-user-profile/$userId');
  }

  // Navegar a ApplicationsManagement
  void goToApplicationsManagement(
    BuildContext context, {
    required String planId,
    required String planTitle,
  }) {
    context.push(
      '/applications-management/$planId',
      extra: {'planTitle': planTitle},
    );
  }

  // Simular el método generateRoute para mantener compatibilidad con código legacy
  Route<dynamic> generateRoute(RouteSettings settings) {
    logger.w('Advertencia: Usando el método legacy generateRoute. '
        'Considera migrar a los métodos de GoRouter.');

    // Redirigir al router principal
    final String screenName = settings.name ?? '/';
    router.go(screenName, extra: settings.arguments);

    // Este código nunca se ejecutará realmente porque GoRouter manejará la navegación,
    // pero lo incluimos por compatibilidad
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Material(child: Text('Redirigiendo...'))),
      ),
    );
  }
}

// Observer para hacer log de la navegación - Versión optimizada
class GoRouterObserver extends NavigatorObserver {
  final Logger logger;
  final Map<String, int> _routeStartTimes = {};
  static const int _maxTrackedRoutes = 10;

  GoRouterObserver(this.logger);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String screenName = route.settings.name ?? 'unnamed';
    _routeStartTimes[screenName] = DateTime.now().millisecondsSinceEpoch;

    if (_routeStartTimes.length > _maxTrackedRoutes) {
      final List<String> keys = _routeStartTimes.keys.toList();
      for (int i = 0; i < keys.length - _maxTrackedRoutes; i++) {
        _routeStartTimes.remove(keys[i]);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String screenName = route.settings.name ?? 'unnamed';

    if (kDebugMode) {
      final int? startTime = _routeStartTimes[screenName];
      if (startTime != null) {
        final int elapsedMs = DateTime.now().millisecondsSinceEpoch - startTime;
        if (elapsedMs > 100) {
          logger.d('Navegación: $screenName - Tiempo: ${elapsedMs}ms');
        }
        _routeStartTimes.remove(screenName);
      }
    } else {
      _routeStartTimes.remove(screenName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      final String newName = newRoute?.settings.name ?? 'unnamed';
      _routeStartTimes[newName] = DateTime.now().millisecondsSinceEpoch;

      if (oldRoute?.settings.name != null) {
        _routeStartTimes.remove(oldRoute!.settings.name);
      }
    }
  }
}

// Pantalla de ruta desconocida
class UnknownRouteScreen extends StatelessWidget {
  final String routePath;
  final String? errorMessage;

  const UnknownRouteScreen({
    super.key,
    required this.routePath,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página no encontrada'),
        backgroundColor: AppColors.brandYellow,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Ruta no encontrada!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'La ruta "$routePath" a la que intentas acceder no existe.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Error: $errorMessage',
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.success),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.navigateTo(AppRouter.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Ir a la pantalla principal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extensión para acceder fácilmente al router desde cualquier BuildContext
extension RouterExtension on BuildContext {
  // Acceso al router singleton
  AppRouter get router => AppRouter();

  // Navegación básica con historial mejorado
  void goBack({String? fallbackRoute}) {
    if (canPop()) {
      pop();
    } else {
      // Si no podemos hacer pop, vamos a la ruta alternativa o al home
      navigateTo(fallbackRoute ?? AppRouter.home);
    }
  }

  // Verificar si podemos volver a una ruta específica en el historial
  bool canGoBackTo(String route) {
    final RouteMatchBase? match = GoRouter.of(this)
        .routerDelegate
        .currentConfiguration
        .matches
        .where((RouteMatchBase match) => match.matchedLocation == route)
        .firstOrNull;
    return match != null;
  }

  // Volver a una ruta específica del historial si existe, o a una ruta por defecto
  void goBackToRoute(String targetRoute, {String? fallbackRoute}) {
    if (canGoBackTo(targetRoute)) {
      // Si la ruta está en el historial, volver a ella
      GoRouter.of(this).go(targetRoute);
    } else {
      // Si no está en el historial, ir a la ruta alternativa o al home
      navigateTo(fallbackRoute ?? AppRouter.home);
    }
  }

  void goToHome() => navigateTo(AppRouter.home);

  // Reemplazar el método push2 con un método más claro
  void pushRoute(String path, {Object? extra}) =>
      GoRouter.of(this).push(path, extra: extra);

  // Método principal de navegación - conserva historial
  void navigateTo(String path, {Object? extra}) =>
      GoRouter.of(this).go(path, extra: extra);

  // Método de navegación que reemplaza la pantalla actual
  void replaceWith(String path, {Object? extra}) =>
      GoRouter.of(this).replace(path, extra: extra);

  // Métodos para navegación con parámetros nombrados
  void appPushNamed(String name,
          {Map<String, String>? params,
          Map<String, dynamic>? queryParams,
          Object? extra}) =>
      GoRouter.of(this).pushNamed(name,
          pathParameters: params ?? {},
          queryParameters: queryParams ?? {},
          extra: extra);

  void appGoNamed(String name,
          {Map<String, String>? params,
          Map<String, dynamic>? queryParams,
          Object? extra}) =>
      GoRouter.of(this).goNamed(name,
          pathParameters: params ?? {},
          queryParameters: queryParams ?? {},
          extra: extra);

  // Método para extraer extra params de manera segura
  T? getExtraAs<T>() {
    final GoRouterState state = GoRouterState.of(this);
    return state.extra as T?;
  }

  // Método para extraer parámetros de ruta
  String getParam(String name, {String defaultValue = ''}) {
    final GoRouterState state = GoRouterState.of(this);
    return state.pathParameters[name] ?? defaultValue;
  }

  // Métodos para manejar operaciones comunes de navegación

  /// Cierra la pantalla actual y devuelve un resultado
  void closeScreen<T>([T? result]) => Navigator.of(this).pop(result);

  /// Cierra todas las pantallas hasta la raíz
  void closeToRoot() => Navigator.of(this, rootNavigator: true).pop();

  /// Comprueba si se puede cerrar la pantalla actual
  bool canCloseScreen() => Navigator.of(this).canPop();

  /// Muestra un diálogo con GoRouter (compatible con web)
  Future<T?> showAppDialog<T>({required Widget dialog}) {
    return showDialog<T>(context: this, builder: (_) => dialog);
  }

  /// Muestra un modal bottom sheet con GoRouter (compatible con web)
  Future<T?> showAppBottomSheet<T>({required Widget sheet}) {
    return showModalBottomSheet<T>(context: this, builder: (_) => sheet);
  }
}
