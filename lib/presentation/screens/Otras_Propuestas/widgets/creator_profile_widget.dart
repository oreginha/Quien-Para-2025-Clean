// lib/presentation/screens/Otras_Propuestas/widgets/creator_profile_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

/// Widget que muestra el perfil del creador del plan
class CreatorProfileWidget extends StatelessWidget {
  final String creatorId;
  final bool isDarkMode;

  const CreatorProfileWidget({
    super.key,
    required this.creatorId,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(creatorId).get(),
      builder: (context, creatorSnapshot) {
        if (creatorSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.brandYellow),
          );
        }

        final creatorData =
            creatorSnapshot.data?.data() as Map<String, dynamic>? ?? {};
        final String creatorName =
            (creatorData['name'] as String?) ?? 'Usuario';
        final List<dynamic> photoUrls =
            creatorData['photoUrls'] as List<dynamic>? ?? [];
        final String photoUrl =
            photoUrls.isNotEmpty ? photoUrls[0] as String : '';
        final int age = (creatorData['age'] as int?) ?? 0;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(isDarkMode),
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.getBorder(isDarkMode).withAlpha((0.2 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Foto de perfil
              Container(
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
                  backgroundColor: AppColors.getCardBackground(isDarkMode),
                  backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl.isEmpty
                      ? Text(
                          creatorName.isNotEmpty
                              ? creatorName[0].toUpperCase()
                              : '?',
                          style: AppTypography.heading2(isDarkMode).copyWith(
                            color: AppColors.brandYellow,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              // Información del creador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creatorName,
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (age > 0) ...[
                      Text(
                        '$age años',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: (isDarkMode ? Colors.white : Colors.black).withAlpha((0.87 * 255).round()),
                            ),
                      ),
                    ],
                    // Nivel y valoración del usuario
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        if (creatorData['level'] != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.brandYellow
                                  .withAlpha((0.3 * 255).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              creatorData['level'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.brandYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.xl),
                        ],
                        if (creatorData['rating'] != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.brandYellow
                                  .withAlpha((0.3 * 255).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.brandYellow,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  (creatorData['rating'] as num)
                                      .toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.brandYellow,
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
              ),
              // Ver perfil botón
              IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    size: 18, color: AppColors.brandYellow),
                onPressed: () {
                  context.push('/otherUserProfile/$creatorId');
                },
                tooltip: 'Ver perfil completo',
              ),
            ],
          ),
        );
      },
    );
  }
}
