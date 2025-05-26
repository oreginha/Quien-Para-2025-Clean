// lib/presentation/widgets/cards/plan_card_types/other_user_plan_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card_utils.dart';

/// Tarjeta para mostrar planes creados por otros usuarios
class OtherUserPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final DateTime? date;
  final String planId;
  final String creatorId;
  final Map<String, dynamic>? creatorData;

  const OtherUserPlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.planId,
    required this.creatorId,
    this.date,
    this.creatorData,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      color: AppColors.getCardBackground(isDarkMode),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      elevation: AppElevation.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, isDarkMode),
          _buildContent(context, isDarkMode),
        ],
      ),
    );
  }

  /// Construye el encabezado de la tarjeta con la imagen y el creador
  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          // Imagen del plan
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (kDebugMode) {
                          print('Error cargando imagen del plan: $error');
                        }
                        return Container(
                          color: AppColors.getSecondaryBackground(isDarkMode),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: AppColors.getTextSecondary(isDarkMode),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.getSecondaryBackground(isDarkMode),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                      ),
                    ),
            ),
          ),
          // Información del creador - Se maneja de forma condicional
          if (creatorData != null || creatorId.isNotEmpty)
            _buildCreatorInfo(context, isDarkMode),
        ],
      ),
    );
  }

  /// Construye el contenido principal de la tarjeta
  Widget _buildContent(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Nombre y edad del usuario (opcional, si ya tenemos los datos)
          if (creatorData != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s),
              child: Text(
                '${creatorData?['name'] ?? 'Usuario'}, ${creatorData?['age'] ?? '?'}',
                style: AppTypography.bodyMedium(isDarkMode),
              ),
            ),

          // Título del plan
          Text(title, style: AppTypography.heading5(isDarkMode)),
          const SizedBox(height: AppSpacing.s),

          // Descripción
          Text(
            description,
            style: AppTypography.bodyMedium(isDarkMode),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.m),

          // Detalles del plan
          Row(
            children: <Widget>[
              PlanCardUtils.buildDetailChip(
                Icons.calendar_today,
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date!)
                    : 'Fecha no especificada',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: AppSpacing.s),
              PlanCardUtils.buildDetailChip(
                Icons.location_on,
                location.isNotEmpty ? location : 'Sin ubicación',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),

          // Botón de acción
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de detalle de propuesta de otros
                context.push(
                  '/otherProposalDetail/$planId',
                  extra: <String, Object>{'isCreator': false},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandYellow,
                foregroundColor: isDarkMode
                    ? Colors.black
                    : AppColors.lightTextPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                elevation: AppElevation.button,
              ),
              child: Text(
                '¡Me interesa!',
                style: AppTypography.buttonLarge(isDarkMode),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la información del creador para mostrar en la tarjeta
  Widget _buildCreatorInfo(BuildContext context, bool isDarkMode) {
    // Si ya tenemos los datos del creador, los usamos directamente
    if (creatorData != null) {
      return _buildCreatorInfoFromData(context, creatorData!, isDarkMode);
    }

    // Si no, los obtenemos de Firestore
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .get(),
      builder: (context, userSnapshot) {
        // Obtener datos del usuario
        final Map<String, dynamic>? userData =
            userSnapshot.data?.data() as Map<String, dynamic>?;

        if (userData == null && !userSnapshot.hasData) {
          return const SizedBox(); // Mientras carga, no mostramos nada
        }

        return _buildCreatorInfoFromData(context, userData ?? {}, isDarkMode);
      },
    );
  }

  /// Construye el widget de información del creador a partir de datos
  Widget _buildCreatorInfoFromData(
    BuildContext context,
    Map<String, dynamic> userData,
    bool isDarkMode,
  ) {
    return Positioned(
      left: AppSpacing.m,
      bottom: AppSpacing.m,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/otherUserProfile/$creatorId');
          },
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandYellow, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.getSecondaryBackground(isDarkMode),
              backgroundImage:
                  userData['photoUrls'] != null &&
                      (userData['photoUrls'] as List).isNotEmpty
                  ? NetworkImage(userData['photoUrls'][0] as String)
                  : null,
              child:
                  (userData['photoUrls'] == null ||
                      (userData['photoUrls'] as List).isEmpty)
                  ? Icon(
                      Icons.person,
                      color: AppColors.getTextSecondary(isDarkMode),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
