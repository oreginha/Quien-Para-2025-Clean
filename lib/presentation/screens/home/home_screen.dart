// lib/presentation/screens/home/home_screen.dart
// ignore_for_file: always_specify_types, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/loading/loading_overlay.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import '../../../core/utils/performance_logger.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Mantener estado cuando se navega entre tabs para evitar reconstrucción costosa
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    PerformanceLogger.logInit('HomeScreen');
  }

  @override
  void dispose() {
    PerformanceLogger.logDispose('HomeScreen');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necesario para AutomaticKeepAliveClientMixin

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) {
        // Solo reconstruir cuando los datos del usuario cambien
        return previous.user != current.user ||
            previous.status != current.status;
      },
      builder: (BuildContext context, AuthState state) {
        if (state.status == AuthStatus.loading) {
          return const LoadingOverlay();
        }

        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDarkMode = themeProvider.isDarkMode;

        // AppBar para la pantalla de home
        final homeAppBar = _buildAppBar(context);

        // Contenido principal de la pantalla de home (con SafeArea para evitar problemas con notches)
        final Widget homeContent = SafeArea(
          child: _buildOptimizedBody(context, state),
        );

        // Usar el nuevo componente responsive
        return NewResponsiveScaffold(
          screenName: 'HomeScreen',
          darkPrimaryBackground:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: homeAppBar,
          body: homeContent,
          currentIndex: 2, // Índice por defecto (Home)
          webTitle: '¿Quién para?', // Título específico para la versión web
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return AppBar(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      title: Text(
        '¿Quién para?',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.settings,
          color: isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        onPressed: () => context.push(AppRouter.settings),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () => context.push(AppRouter.searchFilters),
        ),
      ],
    );
  }

  Widget _buildOptimizedBody(BuildContext context, AuthState state) {
    // Obtener el proveedor de tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores según el tema
    final textPrimary =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // Extraer datos de usuario de manera eficiente
    final Map<String, dynamic> userData = state.user ?? <String, dynamic>{};
    final String name = userData['name'] as String? ?? 'Facu';
    final int age = userData['age'] as int? ?? 32;
    final String? photoUrl = userData['photoUrl'] as String?;
    final String level = userData['level'] as String? ?? 'Explorador';
    final double rating = userData['rating'] as double? ?? 0.0;

    // Construcción eficiente del cuerpo de la pantalla
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Perfil del usuario
          _buildProfileSection(context,
              name: name,
              age: age,
              photoUrl: photoUrl,
              level: level,
              rating: rating),

          const SizedBox(height: 30),

          // Planes disponibles
          _buildPlanCards(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context, {
    required String name,
    required int age,
    String? photoUrl,
    required String level,
    required double rating,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores según el tema
    final textPrimary =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: <Widget>[
          // Círculo de perfil grande
          GestureDetector(
            onTap: () => context.push(AppRouter.profile),
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? AppColors.darkSecondaryBackground
                        : AppColors.lightSecondaryBackground,
                  ),
                  child: ClipOval(
                    child: photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildProfileIcon(textSecondary),
                          )
                        : _buildProfileIcon(textSecondary),
                  ),
                ),
                // Botón de editar
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => context.push(AppRouter.editProfile),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.brandYellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Nombre
          Text(
            name,
            style: TextStyle(
              color: textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Edad
          Text(
            age > 0 ? '$age años' : '',
            style: TextStyle(
              color: textSecondary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          // Rating y nivel
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.brandYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: AppColors.lightTextPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rating > 0 ? rating.toStringAsFixed(1) : 'N/A',
                      style: const TextStyle(
                        color: AppColors.lightTextPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3182CE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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

  Widget _buildProfileIcon(Color iconColor) {
    return Center(
      child: Icon(
        Icons.person,
        size: 80,
        color: iconColor.withAlpha(127), // Updated from withOpacity
      ),
    );
  }

  Widget _buildPlanCards(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores según el tema
    final textPrimary =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Planes disponibles',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 20),
          // Tarjetas verticales
          _buildPlanCard(
            context,
            icon: '🆓',
            title: 'FREE',
            features: const <String>[
              '3 planes/mes',
              'Chat básico',
              'Perfil simple'
            ],
            cardColor: AppColors.brandYellow,
            isFreePlan: true,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            icon: '👑',
            title: 'Plus',
            features: const <String>[
              '10 planes/mes',
              'Chat grupal',
              'Perfil destacado'
            ],
            cardColor: AppColors.accentRed,
            isFreePlan: false,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String icon,
    required String title,
    required List<String> features,
    required Color cardColor,
    required bool isFreePlan,
    required bool isDarkMode,
  }) {
    final textColor = isFreePlan
        ? (isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // Updated from withOpacity
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Encabezado con icono y título
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              // Etiqueta FREE o Plus
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isFreePlan
                      ? const Color(0xFF3182CE)
                      : Colors.white.withAlpha(77), // Updated from withOpacity
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Lista de características
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: isFreePlan ? AppColors.success : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
