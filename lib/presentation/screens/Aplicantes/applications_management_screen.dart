// lib/presentation/screens/applications_management_screen.dart
// ignore_for_file: inference_failure_on_function_invocation, always_specify_types, avoid_dynamic_calls, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/presentation/bloc/matching/matching_bloc.dart';
import 'package:quien_para/presentation/bloc/matching/matching_event.dart';
import 'package:quien_para/presentation/bloc/matching/matching_state.dart';
import 'package:quien_para/presentation/utils/application_status_widget.dart';
import 'package:quien_para/presentation/widgets/loading/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/application/application_entity.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../core/theme/app_theme.dart';

class ApplicationsManagementScreen extends StatefulWidget {
  final String planId;
  final String planTitle;

  const ApplicationsManagementScreen({
    super.key,
    required this.planId,
    required this.planTitle,
  });

  @override
  State<ApplicationsManagementScreen> createState() =>
      _ApplicationsManagementScreenState();
}

class _ApplicationsManagementScreenState
    extends State<ApplicationsManagementScreen> {
  final UserRepositoryImpl _userRepository = UserRepositoryImpl(
    mapper: UserMapper(),
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
    auth: FirebaseAuth.instance,
    cache:
        UserCache(), // Using UserCache implementation from data/datasources/local
  );
  Map<String, dynamic> _userProfiles = <String, dynamic>{};
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    context.read<MatchingBloc>().add(
          MatchingEvent.loadPlanApplications(widget.planId),
        );
  }

  Future<void> _loadUserProfiles(
    final List<ApplicationEntity> applications,
  ) async {
    // Cargar perfiles de usuario para mostrar detalles
    final Map<String, dynamic> profiles = <String, dynamic>{};
    for (ApplicationEntity app in applications) {
      if (!_userProfiles.containsKey(app.applicantId)) {
        try {
          final Map<String, dynamic> userProfile = (await _userRepository
              .getUserProfileById(app.applicantId)) as Map<String, dynamic>;
          profiles[app.applicantId] = userProfile;
        } catch (e) {
          logger.d('Error cargando perfil del usuario ${app.applicantId}: $e');
        }
      }
    }

    if (mounted) {
      setState(() {
        _userProfiles = <String, dynamic>{..._userProfiles, ...profiles};
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation ?? 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aplicantes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Text(
              widget.planTitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.read<MatchingBloc>().add(
                    MatchingEvent.loadPlanApplications(widget.planId),
                  );
            },
            tooltip: 'Refrescar aplicaciones',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).extension<AppTheme>()?.backgroundGradient,
        ),
        child: BlocConsumer<MatchingBloc, MatchingState>(
          listener: (final BuildContext context, final MatchingState state) {
            state.when(
              initial: () {},
              loading: () {},
              userApplicationsLoaded:
                  (final List<ApplicationEntity> applications) {},
              planApplicationsLoaded:
                  (final List<ApplicationEntity> applications) {
                _loadUserProfiles(applications);
              },
              applicationActionSuccess:
                  (final String message, final ApplicationEntity application) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.darkBackground,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // Recargar las aplicaciones después de una acción exitosa
                context.read<MatchingBloc>().add(
                      MatchingEvent.loadPlanApplications(widget.planId),
                    );
              },
              error: (final String message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.accentRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
          builder: (final BuildContext context, final MatchingState state) {
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(color: AppColors.brandYellow),
              ),
              loading: () => const LoadingOverlay(
                isLoading: true,
                child: SizedBox.shrink(),
              ),
              userApplicationsLoaded: (final _) => const Center(
                child: Text('Vista incorrecta. Regrese a la página anterior.'),
              ),
              planApplicationsLoaded:
                  (final List<ApplicationEntity> applications) {
                if (applications.isEmpty) {
                  return _buildEmptyApplicationsView();
                }
                return _buildApplicationsListView(applications);
              },
              applicationActionSuccess: (final _, final __) =>
                  _buildSuccessView(),
              error: (final String message) => _buildErrorView(message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyApplicationsView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.m),
        margin: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).shadowColor.withAlpha((0.2 * 255).round()),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person_off,
              size: 80,
              color: Theme.of(context).dividerColor,
            ),
            SizedBox(height: AppSpacing.l),
            Text(
              'Aún no hay aplicaciones para este plan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Comparte tu plan para recibir solicitudes de otros usuarios interesados',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<MatchingBloc>().add(
                          MatchingEvent.loadPlanApplications(widget.planId),
                        );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refrescar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: AppSpacing.m,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.l),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                OutlinedButton.icon(
                  onPressed: () {
                    // Compartir el plan (se podría implementar la funcionalidad de compartir)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de compartir en desarrollo'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir plan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: AppSpacing.m,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.l),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsListView(
    final List<ApplicationEntity> applications,
  ) {
    // Separar aplicaciones por estado
    final pendingApplications =
        applications.where((app) => app.status == 'pending').toList();
    final acceptedApplications =
        applications.where((app) => app.status == 'accepted').toList();
    final rejectedApplications =
        applications.where((app) => app.status == 'rejected').toList();

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor:
          Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
      onRefresh: () async {
        context.read<MatchingBloc>().add(
              MatchingEvent.loadPlanApplications(widget.planId),
            );
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          // Contador y resumen de aplicaciones
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.l),
            ),
            child: Column(
              children: [
                Text(
                  'Resumen de aplicaciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: AppSpacing.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCountBadge(
                      'Pendientes',
                      pendingApplications.length,
                      Colors.orange,
                    ),
                    _buildCountBadge(
                      'Aceptadas',
                      acceptedApplications.length,
                      Colors.green,
                    ),
                    _buildCountBadge(
                      'Rechazadas',
                      rejectedApplications.length,
                      AppColors.accentRed,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // Sección de aplicaciones pendientes
          if (pendingApplications.isNotEmpty) ...[
            _buildSectionHeader(
              'Pendientes',
              Icons.hourglass_empty,
              AppColors.warning,
            ),
            ...pendingApplications.map(
              (application) => _buildApplicationCard(
                context,
                application,
                _userProfiles[application.applicantId],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
          ],

          // Sección de aplicaciones aceptadas
          if (acceptedApplications.isNotEmpty) ...[
            _buildSectionHeader(
              'Aceptadas',
              Icons.check_circle,
              AppColors.success,
            ),
            ...acceptedApplications.map(
              (application) => _buildApplicationCard(
                context,
                application,
                _userProfiles[application.applicantId],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
          ],

          // Sección de aplicaciones rechazadas
          if (rejectedApplications.isNotEmpty) ...[
            _buildSectionHeader(
              'Rechazadas',
              Icons.cancel,
              AppColors.accentRed,
            ),
            ...rejectedApplications.map(
              (application) => _buildApplicationCard(
                context,
                application,
                _userProfiles[application.applicantId],
              ),
            ),
          ],

          // Espacio al final para evitar que el FAB cubra contenido
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCountBadge(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withAlpha((0.2 * 255).round()),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.m, bottom: AppSpacing.m),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.s),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        margin: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).shadowColor.withAlpha((0.2 * 255).round()),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              '¡Acción completada con éxito!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'La aplicación ha sido procesada correctamente y se ha notificado al usuario',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MatchingBloc>().add(
                      MatchingEvent.loadPlanApplications(widget.planId),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Ver aplicaciones'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.m,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.l),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(final String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        margin: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.l),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).shadowColor.withAlpha((0.2 * 255).round()),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Ha ocurrido un error',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MatchingBloc>().add(
                      MatchingEvent.loadPlanApplications(widget.planId),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.m,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.l),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(
    final BuildContext context,
    final ApplicationEntity application,
    final dynamic userProfile,
  ) {
    if (userProfile == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: CircularProgressIndicator(color: AppColors.brandYellow),
          ),
        ),
      );
    }

    final Map<String, dynamic> profile = userProfile as Map<String, dynamic>;
    final String displayName = profile['name'] as String? ?? 'Usuario Anónimo';
    final List<dynamic>? photoURLs = profile['photoUrls'] as List<dynamic>?;
    final String photoURL = photoURLs != null && photoURLs.isNotEmpty
        ? photoURLs[0] as String
        : 'https://via.placeholder.com/150';
    final String? email = profile['email'] as String?;
    final int age = profile['age'] as int? ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Column(
        children: [
          // Información del usuario
          ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.l),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.brandYellow, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.2 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightSecondaryBackground,
                backgroundImage: NetworkImage(photoURL),
                onBackgroundImageError: (final Object e, final StackTrace? s) =>
                    const Icon(Icons.person),
              ),
            ),
            title: Text(
              displayName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                if (age > 0)
                  Text(
                    '$age años',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                if (email != null && email.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(
                                alpha:
                                    AppTheme.of(context).mediumEmphasisOpacity,
                              ),
                        ),
                  ),
                ],
                // Mostrar badges para nivel y calificación si están disponibles
                const SizedBox(height: AppSpacing.s),
                Row(
                  children: [
                    if (profile['level'] != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brandYellow.withAlpha(
                            (0.3 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          profile['level'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                    ],
                    if (profile['rating'] != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brandYellow.withAlpha(
                            (0.3 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.brandYellow,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (profile['rating'] as num).toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.brandYellow,
              ),
              onPressed: () {
                // Navegar al perfil de usuario
                context.push('/other-user-profile/${application.applicantId}');
              },
              tooltip: 'Ver perfil completo',
            ),
          ),

          // Widget para mostrar el estado y acciones
          ApplicationStatusWidget(application: application, isCreator: true),
        ],
      ),
    );
  }
}
