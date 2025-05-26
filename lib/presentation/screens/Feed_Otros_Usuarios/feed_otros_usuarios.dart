// lib/presentation/screens/Feed_Otros_Usuarios/feed_otros_usuarios.dart

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

// Importamos los widgets modulares
import 'widgets/index.dart';

/// Pantalla de perfil de otro usuario
/// Refactorizada para usar el nuevo sistema de responsive scaffold para web y móvil
class FeedOtroUsuario extends StatelessWidget {
  final String userId;

  const FeedOtroUsuario({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Obtener el proveedor de tema para usarlo en toda la UI
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Colores según el tema actual
    final primaryBackground = isDarkMode
        ? ThemeUtils.backgroundDark
        : ThemeUtils.background;
    final secondaryBackground = isDarkMode
        ? ThemeUtils.darkSecondaryBackground
        : ThemeUtils.lightSecondaryBackground;
    final textPrimary = isDarkMode
        ? ThemeUtils.textPrimaryDark
        : ThemeUtils.textPrimary;
    final textSecondary = isDarkMode
        ? ThemeUtils.textSecondaryDark
        : ThemeUtils.textSecondary;
    final borderColor = isDarkMode
        ? ThemeUtils.darkBorder
        : ThemeUtils.lightBorder;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder:
          (
            final BuildContext context,
            final AsyncSnapshot<DocumentSnapshot<Object?>> userSnapshot,
          ) {
            // Si hay un error al cargar los datos
            if (userSnapshot.hasError) {
              return _buildErrorScreen(context, isDarkMode);
            }

            // Mostrar pantalla de carga mientras se obtienen los datos
            if (!userSnapshot.hasData) {
              return _buildLoadingScreen(context, isDarkMode);
            }

            // Extraer los datos del usuario
            final Map<String, dynamic> userData =
                userSnapshot.data!.data() as Map<String, dynamic>? ??
                <String, dynamic>{};
            final List<String> userPhotoUrls = List<String>.from(
              userData['photoUrls'] as List? ?? <String>[],
            );

            // Crear el AppBar personalizado para esta pantalla
            final appBar = AppBar(
              backgroundColor: primaryBackground,
              elevation: 0,
              title: Text(
                userData['name']?.toString() ?? 'Perfil',
                style: TextStyle(
                  color: ThemeUtils.brandYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: ThemeUtils.brandYellow),
            );

            // Contenido principal de la pantalla
            final body = Container(
              color: primaryBackground,
              child: CustomScrollView(
                slivers: <Widget>[
                  // Tarjeta de perfil
                  SliverToBoxAdapter(
                    child: ProfileCardWidget(
                      userData: userData,
                      userPhotoUrls: userPhotoUrls,
                      isDarkMode: isDarkMode,
                      secondaryBackground: secondaryBackground,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      borderColor: borderColor,
                      brandYellow: ThemeUtils.brandYellow,
                    ),
                  ),

                  // Sección de intereses
                  SliverToBoxAdapter(
                    child: InterestsSectionWidget(
                      userData: userData,
                      textPrimary: textPrimary,
                      borderColor: borderColor,
                    ),
                  ),

                  // Sección de planes
                  SliverToBoxAdapter(
                    child: PlansSectionWidget(
                      userId: userId,
                      textPrimary: textPrimary,
                      secondaryBackground: secondaryBackground,
                      borderColor: borderColor,
                      brandYellow: ThemeUtils.brandYellow,
                    ),
                  ),
                ],
              ),
            );

            // Construir la pantalla utilizando NewResponsiveScaffold para soporte web
            return NewResponsiveScaffold(
              screenName: AppRouter.otherUserProfile,
              appBar: appBar,
              body: body,
              currentIndex: -1, // No es una pantalla en la barra de navegación
              webTitle:
                  userData['name']?.toString() ??
                  'Perfil de usuario', // Título para la versión web
              darkPrimaryBackground: isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
            );
          },
    );
  }

  /// Construye la pantalla de error
  Widget _buildErrorScreen(BuildContext context, bool isDarkMode) {
    final primaryBackground = isDarkMode
        ? ThemeUtils.backgroundDark
        : ThemeUtils.background;
    final textPrimary = isDarkMode
        ? ThemeUtils.textPrimaryDark
        : ThemeUtils.textPrimary;

    return NewResponsiveScaffold(
      screenName: 'Error',
      appBar: AppBar(
        backgroundColor: primaryBackground,
        title: Text('Error', style: TextStyle(color: ThemeUtils.brandYellow)),
        iconTheme: IconThemeData(color: ThemeUtils.brandYellow),
      ),
      body: Center(
        child: Text(
          'Error al cargar el perfil',
          style: TextStyle(color: textPrimary),
        ),
      ),
      currentIndex: -1,
      webTitle: 'Error',
      darkPrimaryBackground: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
    );
  }

  /// Construye la pantalla de carga
  Widget _buildLoadingScreen(BuildContext context, bool isDarkMode) {
    final primaryBackground = isDarkMode
        ? ThemeUtils.backgroundDark
        : ThemeUtils.background;

    return NewResponsiveScaffold(
      screenName: 'Cargando',
      appBar: AppBar(
        backgroundColor: primaryBackground,
        title: Text(
          'Cargando...',
          style: TextStyle(color: ThemeUtils.brandYellow),
        ),
        iconTheme: IconThemeData(color: ThemeUtils.brandYellow),
      ),
      body: Center(
        child: CircularProgressIndicator(color: ThemeUtils.brandYellow),
      ),
      currentIndex: -1,
      webTitle: 'Cargando...',
      darkPrimaryBackground: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
    );
  }
}
