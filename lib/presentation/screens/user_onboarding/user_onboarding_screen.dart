// lib/presentation/screens/user_onboarding/user_onboarding_screen.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/profile/user_profile_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/presentation/widgets/common/common_widgets.dart';
import 'package:quien_para/presentation/widgets/modals/success_modal_perfil.dart';
import 'package:quien_para/data/repositories/user/user_repository_impl.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/screens/user_onboarding/steps/add_photos_step.dart';
import 'package:quien_para/presentation/screens/user_onboarding/steps/profile_review_step.dart';

import 'steps/name_input_step.dart';
import 'steps/age_input_step.dart';
import 'steps/gender_input_step.dart';
import 'steps/location_input_step.dart';
import 'steps/interests_step.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final UserProfileBloc _userProfileBloc;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final UserCache _userCache = UserCache();

  @override
  void initState() {
    super.initState();

    // Inicializar caché
    _userCache.init();

    // Configuración de la animación para la barra de progreso
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1 / steps.length,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Create UserProfileBloc with proper Firebase instances
    _userProfileBloc = UserProfileBloc(
      userRepository: UserRepositoryImpl(
        mapper: UserMapper(),
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
        auth: FirebaseAuth.instance,
        cache: _userCache,
      ),
    );
    // Load existing profile data if any
    _userProfileBloc.add(LoadUserProfileEvent());
  }

  void _nextPage() {
    if (_currentPage < steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Animar la barra de progreso
      _animationController.animateTo(
        (_currentPage + 2) / steps.length,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Animar la barra de progreso
      _animationController.animateTo(
        _currentPage / steps.length,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completePerfil() {
    if (_userProfileBloc.state.status == UserProfileStatus.loading) return;
    _userProfileBloc.add(SaveUserProfileEvent());

    // Animación de finalización
    _animationController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Notificar al AuthCubit que el onboarding está completo
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AuthCubit>().completeOnboarding();
      }
    });
  }

  @override
  void dispose() {
    _userProfileBloc.close();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocProvider.value(
      value: _userProfileBloc,
      child: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (final BuildContext context, final UserProfileState state) {
          if (state.status == UserProfileStatus.saved) {
            // Mostrar modal de éxito antes de navegar
            showSuccessModalPerfil(
              context: context,
              title: '¡Perfil creado con éxito!',
              message: 'Tu perfil ha sido guardado correctamente.',
              onConfirm: () {
                context.read<AuthCubit>().completeOnboarding();
                context.go(AppRouter.proposalsScreen);
              },
            );
          } else if (state.status == UserProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.errorMessage ?? 'Error al guardar el perfil'),
                backgroundColor: AppColors.brandYellow,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            // Hide keyboard when tapping outside the text fields
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: isDarkMode
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Progress bar animation
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step numbers
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Paso ${_currentPage + 1} de ${steps.length}',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (_currentPage > 0)
                                        GestureDetector(
                                          onTap: _previousPage,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_back_ios,
                                                size: 16,
                                                color: AppColors.brandYellow,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Volver',
                                                style: TextStyle(
                                                  color: AppColors.brandYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Progress bar
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.darkSecondaryBackground
                                        : AppColors.lightSecondaryBackground,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _progressAnimation.value,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.brandYellow,
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Header animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _buildHeader(_currentPage),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                      ),

                      // Page content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (final int page) {
                            setState(() => _currentPage = page);
                          },
                          children: <Widget>[
                            NameInputStep(
                                onNext: () => _nextPage(),
                                onBack: () => _previousPage()),
                            AgeInputStep(
                                onNext: () => _nextPage(),
                                onBack: () => _previousPage()),
                            GenderInputStep(
                                onNext: () => _nextPage(),
                                onBack: () => _previousPage()),
                            LocationInputStep(
                                onNext: () => _nextPage(),
                                onBack: () => _previousPage()),
                            AddPhotosStep(onNext: () => _nextPage()),
                            InterestsStep(onComplete: () => _nextPage()),
                            ProfileReviewStep(
                              onConfirm: _completePerfil,
                              onViewProfile: () => context.push("/profile"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Loading overlay
                  if (_userProfileBloc.state.status ==
                      UserProfileStatus.loading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkSecondaryBackground
                                : AppColors.lightSecondaryBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.brandYellow),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Guardando tu perfil...',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int step) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.brandYellow.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                steps[step]['icon'] as String,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            steps[step]['title'] as String,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            steps[step]['subtitle'] as String,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
