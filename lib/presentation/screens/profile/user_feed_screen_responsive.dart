// lib/presentation/screens/profile/user_feed_screen_responsive.dart
// ignore_for_file: always_specify_types, avoid_dynamic_calls, inference_failure_on_function_invocation, inference_failure_on_instance_creation, use_build_context_synchronously, unused_element, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:quien_para/presentation/widgets/responsive/responsive_scaffold.dart';

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
          context.read<PlanBloc>().add(
                PlanEvent.updateField(
                  field: 'loadMorePlans',
                  value: querySnapshot.docs
                      .map(
                        (final QueryDocumentSnapshot e) =>
                            e.data() as Map<String, dynamic>,
                      )
                      .toList(),
                ),
              );
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
            body: Center(child: Text('No has iniciado sesión')),
          );
        }

        if (state.status == AuthStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.getBackground(isDarkMode),
            body: Center(
              child: CircularProgressIndicator(color: AppColors.brandYellow),
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

          return ResponsiveScaffold(
            screenName: '/profile',
            appBar: _buildAppBar(context, isDarkMode),
            body: Container(
              color: AppColors.getBackground(isDarkMode),
              child: RefreshIndicator(
                color: AppColors.brandYellow,
                onRefresh: () async {
                  context.read<PlanBloc>().add(
                        PlanEvent.updateField(
                          field: 'loadUserPlans',
                          value: userId,
                        ),
                      );
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
                  ],
                ),
              ),
            ),
            currentIndex: 3, // Índice para perfil
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
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go('/');
          }
        },
      ),
      title: Text('Mi Perfil', style: AppTypography.appBarTitle(isDarkMode)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: AppColors.getTextPrimary(isDarkMode)),
          onPressed: () => context.push(AppRouter.editProfile),
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
    final String formattedDate = memberSince != null
        ? DateFormat('MMMM yyyy', 'es').format(memberSince)
        : 'Fecha desconocida';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        borderRadius: BorderRadius.circular(AppSpacing.m),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar y nombre
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.brandYellow.withOpacity(0.2),
                backgroundImage: userPhotoUrl != null && userPhotoUrl.isNotEmpty
                    ? NetworkImage(userPhotoUrl)
                    : null,
                child: userPhotoUrl == null || userPhotoUrl.isEmpty
                    ? Icon(Icons.person, size: 40, color: AppColors.brandYellow)
                    : null,
              ),
              const SizedBox(width: AppSpacing.l),
              // Nombre y edad
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: AppTypography.heading2(isDarkMode),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (userAge > 0)
                      Text(
                        '$userAge años',
                        style: AppTypography.bodyMedium(isDarkMode).copyWith(
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Miembro desde $formattedDate',
                      style: AppTypography.bodySmall(
                        isDarkMode,
                      ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserPlansHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mis Planes', style: AppTypography.heading1(isDarkMode)),
          TextButton(
            onPressed: () => context.push(AppRouter.proposalsScreen),
            child: Text(
              'Ver todos',
              style: AppTypography.bodyMedium(isDarkMode).copyWith(
                color: AppColors.brandYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPlansList(
    BuildContext context,
    String userId,
    bool isDarkMode,
  ) {
    // Usando StreamBuilder en lugar de BlocBuilder para evitar el error de tipo
    // ya que PlanBloc no implementa StateStreamable<Map<String, dynamic>>
    return StreamBuilder<Map<String, dynamic>>(
      // Creamos un stream que escucha los cambios en el estado del PlanBloc
      stream: Stream.value(
        context.read<PlanBloc>().state as Map<String, dynamic>,
      ),
      builder: (context, snapshot) {
        final Map<String, dynamic> state = snapshot.data ?? {};

        // Iniciar carga de planes si no hay datos
        if (state['userPlans'] == null) {
          context.read<PlanBloc>().add(
                PlanEvent.updateField(field: 'loadUserPlans', value: userId),
              );
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Mostrar planes del usuario
        final List<dynamic> userPlans = state['userPlans'] ?? [];
        final List<dynamic> loadMorePlans = state['loadMorePlans'] ?? [];

        // Combinar planes iniciales con planes cargados posteriormente
        final List<dynamic> allPlans = [...userPlans, ...loadMorePlans];

        if (allPlans.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Aún no has creado ningún plan',
                      style: AppTypography.bodyLarge(
                        isDarkMode,
                      ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    ElevatedButton(
                      onPressed: () => context.push(AppRouter.createProposal),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandYellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.l,
                          vertical: AppSpacing.m,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.s),
                        ),
                      ),
                      child: const Text('Crear mi primer plan'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Si hay planes, mostrarlos en una lista
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final plan = allPlans[index];
            // Guardar referencia al último documento para paginación
            if (index == 0 && _lastDocument == null) {
              FirebaseFirestore.instance
                  .collection('plans')
                  .doc(plan['id'])
                  .get()
                  .then((doc) {
                _lastDocument = doc;
              });
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.s,
              ),
              child: GestureDetector(
                onTap: () {
                  context.push('${AppRouter.myPlanDetail}/${plan['id']}');
                },
                child: PlanCard(
                  planData: plan,
                  planId: plan['id'],
                  cardType: PlanCardType.myPlan,
                ),
              ),
            );
          }, childCount: allPlans.length),
        );
      },
    );
  }
}
