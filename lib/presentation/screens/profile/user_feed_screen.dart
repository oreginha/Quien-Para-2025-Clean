// ignore_for_file: always_specify_types, avoid_dynamic_calls, inference_failure_on_function_invocation, inference_failure_on_instance_creation, use_build_context_synchronously, unused_element, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/auth/auth_state.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_event.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card.dart';
import 'package:quien_para/presentation/widgets/errors/profile_error_widget.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/core/utils/platform_utils.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMorePlans = true;
  DocumentSnapshot? _lastDocument;
  final int _limit = 5;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMorePlans) {
      _loadMorePlans();
    }
  }

  Future<void> _loadMorePlans() async {
    if (_lastDocument == null || !_hasMorePlans) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final AuthState authState = context.read<AuthCubit>().state;
      if (authState.status == AuthStatus.authenticated) {
        final String userId = authState.user?['id'] ?? '';

        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('plans')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(_lastDocument!)
            .limit(_limit)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          _lastDocument = querySnapshot.docs.last;
          context.read<PlanBloc>().add(PlanEvent.updateField(
              field: 'loadMorePlans',
              value: querySnapshot.docs
                  .map((final QueryDocumentSnapshot e) =>
                      e.data() as Map<String, dynamic>)
                  .toList()));
        }

        setState(() {
          _hasMorePlans = querySnapshot.docs.length >= _limit;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (final BuildContext context, final AuthState state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const Scaffold(
            body: Center(
              child: Text('No has iniciado sesión'),
            ),
          );
        }

        if (state.status == AuthStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.getBackground(isDarkMode),
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.brandYellow,
              ),
            ),
          );
        }

        if (state.status == AuthStatus.authenticated) {
          final Map<String, dynamic> userData = state.user ?? {};
          final String userId = userData['id'] ?? '';
          final String userName = userData['name'] ?? 'Usuario';
          final int userAge = userData['age'] ?? 0;
          final String? userPhotoUrl = userData['photoUrl'];
          final DateTime? memberSince = userData['createdAt'] != null
              ? (userData['createdAt'] as Timestamp).toDate()
              : null;

          // Contenido de la pantalla del perfil (contenido "móvil")
          final Widget profileContent = Container(
            color: AppColors.getBackground(isDarkMode),
            child: RefreshIndicator(
              color: AppColors.brandYellow,
              onRefresh: () async {
                context.read<PlanBloc>().add(PlanEvent.updateField(
                    field: 'loadUserPlans', value: userId));
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _buildProfileCard(
                      context,
                      isDarkMode,
                      userName,
                      userAge,
                      userPhotoUrl,
                      memberSince,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildUserPlansHeader(context, isDarkMode),
                  ),
                  _buildUserPlansList(context, userId, isDarkMode),
                  if (_isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brandYellow,
                          ),
                        ),
                      ),
                    ),
                  // Agregar espacio adicional al final para dispositivos móviles
                  if (PlatformUtils.isMobile)
                    SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xxxl),
                    ),
                ],
              ),
            ),
          );

          // Usar el nuevo scaffold responsive
          return NewResponsiveScaffold(
            screenName: '/profile',
            appBar: _buildAppBar(context, isDarkMode),
            body: profileContent,
            currentIndex: 3, // Índice para perfil
            webTitle: 'Mi Perfil', // Título específico para la versión web
          );
        }

        return ProfileErrorWidget(
          title: 'Error de perfil',
          description: 'No se pudo cargar tu perfil',
          onButtonPressed: () {
            context.read<AuthCubit>().checkAuthStatus();
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      leading: IconButton(
        icon:
            Icon(Icons.arrow_back, color: AppColors.getTextPrimary(isDarkMode)),
        onPressed: () => context.go(AppRouter.home),
      ),
      title: Text(
        'Mi Perfil',
        style: AppTypography.appBarTitle(isDarkMode),
      ),
      centerTitle: true,
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: AppSpacing.s),
          decoration: BoxDecoration(
            color: AppColors.brandYellow,
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    bool isDarkMode,
    String userName,
    int userAge,
    String? userPhotoUrl,
    DateTime? memberSince,
  ) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(isDarkMode),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Imagen de perfil
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: userPhotoUrl != null
                  ? Image.network(
                      userPhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.getSecondaryBackground(isDarkMode),
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.getSecondaryBackground(isDarkMode),
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: AppColors.getTextSecondary(isDarkMode),
                      ),
                    ),
            ),
          ),

          // Información del usuario
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              children: [
                // Nombre y edad
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: AppTypography.heading3(isDarkMode),
                    ),
                    if (userAge > 0) ...[
                      const SizedBox(width: AppSpacing.m),
                      Text(
                        userAge.toString(),
                        style: AppTypography.heading3(isDarkMode),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppSpacing.s),

                // Miembro desde
                if (memberSince != null)
                  Text(
                    'Miembro desde ${DateFormat('MMMM yyyy', 'es').format(memberSince)}',
                    style: AppTypography.bodyMedium(isDarkMode).copyWith(
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                  ),

                const SizedBox(height: AppSpacing.l),

                // Estadísticas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(context, isDarkMode, '12', 'Planes'),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.getBorder(isDarkMode),
                    ),
                    _buildStatItem(context, isDarkMode, '48', 'Conexiones'),
                  ],
                ),

                const SizedBox(height: AppSpacing.l),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push(AppRouter.createProposal),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandYellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.m),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.button),
                          ),
                        ),
                        child: Text(
                          'Crear Plan',
                          style: AppTypography.buttonLarge(isDarkMode).copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRouter.myApplications),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.getTextPrimary(isDarkMode),
                          side: BorderSide(
                            color: AppColors.getBorder(isDarkMode),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.m),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.button),
                          ),
                        ),
                        child: Text(
                          'Mis Aplicaciones',
                          style: AppTypography.buttonLarge(isDarkMode),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, bool isDarkMode, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.heading4(isDarkMode),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodyMedium(isDarkMode).copyWith(
            color: AppColors.getTextSecondary(isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildUserPlansHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.m, AppSpacing.l, AppSpacing.m, AppSpacing.s),
      child: Text(
        'Mis Propuestas',
        style: AppTypography.heading5(isDarkMode),
      ),
    );
  }

  Widget _buildUserPlansList(
      BuildContext context, String userId, bool isDarkMode) {
    // Se ha detectado que la consulta podría no estar funcionando correctamente
    // Vamos a agregar logs para diagnóstico y mejorar la consulta
    if (kDebugMode) {
      print('Intentando cargar planes para el usuario: $userId');
    }

    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('plans')
            // Corrección: Según plan_entity.dart, el campo correcto es creatorId, no userId
            .where('creatorId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (final BuildContext context,
            final AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: AppColors.accentRed),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Error al cargar tus planes',
                    style: AppTypography.bodyLarge(isDarkMode),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Es posible que necesites crear un índice en Firestore.',
                    style: AppTypography.bodyMedium(isDarkMode).copyWith(
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(
                  color: AppColors.brandYellow,
                ),
              ),
            );
          }

          final List<DocumentSnapshot> plans = snapshot.data!.docs;

          if (plans.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_neutral,
                    size: 64,
                    color: AppColors.getTextSecondary(isDarkMode)
                        .withAlpha((0.3 * 255).round()),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Aún no has creado planes',
                    style: AppTypography.heading5(isDarkMode),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Comienza creando tu primer plan',
                    style: AppTypography.bodyMedium(isDarkMode).copyWith(
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRouter.createProposal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.m, horizontal: AppSpacing.m),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear mi primer plan'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plans.length,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            itemBuilder: (context, index) {
              final Map<String, dynamic> planData =
                  plans[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: PlanCard(
                  planId: plans[index].id,
                  planData: planData,
                  cardType: PlanCardType.myPlan,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
