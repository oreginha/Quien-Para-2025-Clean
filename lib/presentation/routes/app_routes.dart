// app_routes.dart
// Este archivo contiene solo las definiciones de las rutas

/// Definiciones de rutas estáticas para la aplicación
class AppRoutes {
  // Rutas principales
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile';
  
  // Rutas de propuestas/planes
  static const String proposalsScreen = '/proposalsScreen';
  static const String planes = '/planes';
  static const String mainPlan = '/mainPlan';
  static const String proposal = '/proposal';
  static const String createProposal = '/createProposal';
  static const String proposalDetail = '/proposalDetail';
  static const String planDetail = '/plan/:planId';
  static const String myPlanDetail = '/myPlanDetail/:planId';
  static const String otherProposalDetail = '/otherProposalDetail/:planId';
  
  // Rutas de usuario
  static const String editProfile = '/editProfile';
  static const String userOnboarding = '/user-onboarding';
  static const String phoneAuth = '/phone-auth';
  static const String phoneVerification = '/phone-verification';
  static const String otherUserProfile = '/otherUserProfile/:userId';
  
  // Rutas de aplicaciones
  static const String userApplications = '/user-applications';
  static const String applicationsManagement = '/applications-management/:planId';
  static const String applicationsList = '/applications-list/:planId';
  static const String myApplications = '/my-applications';
  static const String applicantsList = '/applicantsList';
  
  // Rutas de comunicación
  static const String messages = '/messages';
  static const String notifications = '/notifications';
  static const String conversationsList = '/conversations';
  static const String chatDetail = '/chat/:conversationId';
  
  // Rutas de utilidad
  static const String searchFilters = '/search-filters';
  static const String settings = '/settings';
  static const String themeShowcase = '/theme-showcase';
  
  // Rutas de ejemplo/desarrollo
  static const String responsiveExample = '/responsive-example';
  static const String migrationExample = '/migration-example';
  
  // Mapa de índices de navegación para el BottomNavBar
  static final Map<String, int> navigationIndices = {
    conversationsList: 0, // Mensajes
    proposalsScreen: 1, // Propuestas
    home: 2, // Home
    profile: 3, // Perfil
    notifications: 4, // Notificaciones
  };
}
