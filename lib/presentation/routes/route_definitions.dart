// route_definitions.dart
// Este archivo contiene las definiciones completas de todas las rutas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/di/di.dart';
import 'package:quien_para/presentation/screens/Aplicantes/applicants_list_screen.dart';
import 'package:quien_para/presentation/screens/Aplicantes/applications_management_screen.dart';
import 'package:quien_para/presentation/screens/Feed_Otros_Usuarios/feed_otros_usuarios.dart';
import 'package:quien_para/presentation/screens/Login/login_screen.dart';
import 'package:quien_para/presentation/screens/Mis_Propuestas/feed_mis_planes.dart';
import 'package:quien_para/presentation/screens/Mis_Propuestas/mi_plan_detalle.dart';
import 'package:quien_para/presentation/screens/Otras_Propuestas/feed_otras_propuestas.dart';
import 'package:quien_para/presentation/screens/Seetings/settings_screen.dart';
import 'package:quien_para/presentation/screens/auth/auth_wrapper.dart';
import 'package:quien_para/presentation/screens/chat/chat_screen_responsive.dart';
import 'package:quien_para/presentation/screens/create_proposal/onboarding_plan_flow_responsive.dart';
import 'package:quien_para/presentation/screens/example/responsive_example_screen.dart';
import 'package:quien_para/presentation/screens/example/screen_migration_example.dart';
import 'package:quien_para/presentation/screens/home/home_screen.dart';
import 'package:quien_para/presentation/screens/my_applications/my_applications_screen.dart';
import 'package:quien_para/presentation/screens/notifications/notifications_screen.dart';
import 'package:quien_para/presentation/screens/otras_propuestas/Detalles_Propuesta_Otros.dart';
import 'package:quien_para/presentation/screens/phone_auth_screen.dart';
import 'package:quien_para/presentation/screens/profile/edit_profile_screen_responsive.dart';
import 'package:quien_para/presentation/screens/profile/user_feed_screen.dart'
    as user_feed;
import 'package:quien_para/presentation/screens/search/search_filters_screen.dart';
import 'package:quien_para/presentation/screens/theme_showcase/theme_showcase_screen.dart';
import 'package:quien_para/presentation/screens/user_onboarding/user_onboarding_screen.dart';

import '../bloc/applications_management/applications_management_provider.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/matching/matching_bloc.dart';
import '../bloc/notifications/notification_bloc.dart';
import '../bloc/plan/plan_bloc.dart';

import '../screens/chat/conversations_list_screen.dart';
import 'app_routes.dart';
import 'route_transitions.dart';

/// Definición de todas las rutas de la aplicación
class RouteDefinitions {
  /// Obtener todas las rutas para GoRouter
  static List<RouteBase> getRoutes(AuthCubit? authCubit) {
    return [
      // Root route - Ahora va directamente a AuthWrapper
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => RouteTransitions.fadeTransition(
          state: state,
          child: BlocProvider<AuthCubit>.value(
            value: authCubit ?? Provider.of<AuthCubit>(context, listen: false),
            child: const AuthWrapper(),
          ),
        ),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => RouteTransitions.fadeTransition(
          state: state,
          child: const LoginScreen(),
        ),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => RouteTransitions.fadeTransition(
          state: state,
          child: const HomeScreen(),
        ),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const user_feed.UserFeedScreen(),
      ),

      // Edit Profile
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreenResponsive(),
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Theme Showcase
      GoRoute(
        path: AppRoutes.themeShowcase,
        builder: (context, state) => const ThemeShowcaseScreen(),
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<NotificationBloc>(),
          child: const NotificationsScreen(),
        ),
      ),

      // Phone Auth
      GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (context, state) => const PhoneAuthScreen(),
      ),

      // User Onboarding
      GoRoute(
        path: AppRoutes.userOnboarding,
        builder: (context, state) => const UserOnboardingScreen(),
      ),

      // Proposals
      GoRoute(
        path: AppRoutes.proposalsScreen,
        builder: (context, state) => const FeedPropuestas(),
      ),

      // Planes / Main Plan
      GoRoute(
        path: AppRoutes.planes,
        builder: (context, state) => const FeedMisPlanes(title: 'Quien para?'),
      ),

      GoRoute(
          path: AppRoutes.mainPlan,
          builder: (context, state) =>
              const FeedMisPlanes(title: "Quien para?")),

      GoRoute(
        path: AppRoutes.createProposal,
        builder: (context, state) {
          // Extraer los argumentos si existen
          final Map<String, dynamic>? args =
              state.extra as Map<String, dynamic>?;

          return OnboardingPlanFlowResponsive(
            planId: args?['planId'] as String?,
            planData: args?['planData'] as Map<String, dynamic>?,
            isEditing: args?['isEditing'] as bool? ?? false,
          );
        },
      ),

      // Proposal Detail
      GoRoute(
        path: AppRoutes.proposalDetail,
        builder: (context, state) => BlocProvider(
            create: (context) => sl<PlanBloc>(),
            child: const FeedMisPlanes(title: "Quien para?")),
      ),

      // Generic Plan Detail (handles both own and other plans)
      GoRoute(
        path: '/plan/:planId',
        builder: (context, state) {
          final String planId = state.pathParameters['planId'] ?? '';
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final bool isCreator = extras['isCreator'] as bool? ?? false;

          // First check if it's a user's own plan
          if (isCreator) {
            return MyPlanDetailScreen(
              planId: planId,
              isCreator: isCreator,
            );
          } else {
            // Otherwise show as other user's plan
            return MultiBlocProvider(
              providers: [
                BlocProvider<ChatBloc>.value(
                  value: sl<ChatBloc>(),
                ),
              ],
              child: DetallesPropuestaOtros(
                planId: planId,
                isCreator: isCreator,
              ),
            );
          }
        },
      ),

      // My Plan Detail
      GoRoute(
        path: AppRoutes.myPlanDetail,
        builder: (context, state) {
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final String planId = state.pathParameters['planId'] ?? '';
          final bool isCreator = extras['isCreator'] as bool? ?? false;

          return MyPlanDetailScreen(
            planId: planId,
            isCreator: isCreator,
          );
        },
      ),

      // Other User Profile
      GoRoute(
        path: AppRoutes.otherUserProfile,
        builder: (context, state) {
          final String userId = state.pathParameters['userId'] ?? '';
          return FeedOtroUsuario(userId: userId);
        },
      ),

      // Applicants List
      GoRoute(
        path: AppRoutes.applicantsList,
        builder: (context, state) => const ApplicantsListScreen(planId: ''),
      ),

      // Applications Management
      GoRoute(
        path: AppRoutes.applicationsManagement,
        builder: (context, state) {
          final String planId = state.pathParameters['planId'] ?? '';
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final String planTitle = extras['planTitle'] as String? ?? '';

          return ApplicationsManagementProvider(
            child: ApplicationsManagementScreen(
              planId: planId,
              planTitle: planTitle,
            ),
          );
        },
      ),

      // Applications List
      GoRoute(
        path: AppRoutes.applicationsList,
        builder: (context, state) {
          final String planId = state.pathParameters['planId'] ?? '';
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final String planTitle = extras['planTitle'] as String? ?? '';

          return BlocProvider(
            create: (context) => sl<MatchingBloc>(),
            child: ApplicationsManagementScreen(
              planId: planId,
              planTitle: planTitle,
            ),
          );
        },
      ),

      // My Applications
      GoRoute(
        path: AppRoutes.myApplications,
        builder: (context, state) {
          // Extraer el userId del extra si existe
          final Map<String, dynamic>? extras =
              state.extra as Map<String, dynamic>?;
          final String? userId = extras?['userId'] as String?;

          return BlocProvider(
            create: (context) => sl<MatchingBloc>(),
            child: MyApplicationsScreen(userId: userId),
          );
        },
      ),

      // Search Filters
      GoRoute(
        path: AppRoutes.searchFilters,
        builder: (context, state) => const SearchFiltersScreen(),
      ),

      // Other Proposal Detail
      GoRoute(
        path: AppRoutes.otherProposalDetail,
        builder: (context, state) {
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final String planId = state.pathParameters['planId'] ?? '';
          final bool isCreator = extras['isCreator'] as bool? ?? false;

          // Verificación adicional para detectar IDs vacíos
          if (planId.isEmpty) {
            debugPrint('ADVERTENCIA: ID del plan vacío en otherProposalDetail');
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider<ChatBloc>.value(
                value: sl<ChatBloc>(),
              ),
            ],
            child: DetallesPropuestaOtros(
              planId: planId,
              isCreator: isCreator,
            ),
          );
        },
      ),

      // Conversaciones
      GoRoute(
        path: AppRoutes.conversationsList,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ChatBloc>(),
          child: const ConversationsListScreen(),
        ),
      ),

      // Chat detalle
      GoRoute(
        path: AppRoutes.chatDetail,
        builder: (context, state) {
          final String conversationId =
              state.pathParameters['conversationId'] ?? '';
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>? ?? {};
          final String receiverId = extras['receiverId'] as String? ?? '';
          final String receiverName =
              extras['receiverName'] as String? ?? 'Chat';

          return BlocProvider(
            create: (context) => sl<ChatBloc>(),
            child: ChatScreenResponsive(
              conversationId: conversationId,
              receiverId: receiverId,
              receiverName: receiverName,
              chatId: '',
              otherUserName: '',
            ),
          );
        },
      ),

      // Ejemplo Responsive (para demostrar el nuevo enfoque)
      GoRoute(
        path: AppRoutes.responsiveExample,
        builder: (context, state) => const ResponsiveExampleScreen(),
      ),

      // Ejemplo de Migración (para mostrar cómo migrar una pantalla existente)
      GoRoute(
        path: AppRoutes.migrationExample,
        builder: (context, state) => const MigrationExampleScreen(),
      ),
    ];
  }
}
