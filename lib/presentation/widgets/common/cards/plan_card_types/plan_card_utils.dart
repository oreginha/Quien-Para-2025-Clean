// lib/presentation/widgets/cards/utils/plan_card_utils.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

/// Clase de utilidades para las tarjetas de planes
class PlanCardUtils {
  /// Parse una fecha desde diferentes formatos (Timestamp, String)
  static DateTime? parseDate(dynamic dateData) {
    if (dateData == null) return null;

    try {
      if (dateData is Timestamp) {
        return dateData.toDate();
      } else if (dateData is String) {
        return DateTime.parse(dateData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parseando fecha: $e');
      }
    }

    return null;
  }

  /// Obtiene el texto legible para un estado de aplicación
  static String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptada';
      case 'rejected':
        return 'Rechazada';
      default:
        return status;
    }
  }

  /// Obtiene el color de fondo para un estado de aplicación
  static Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade700;
      case 'accepted':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  /// Construye un chip para detalles del plan (fecha, ubicación, etc.)
  static Widget buildDetailChip(
    IconData icon,
    String label, {
    bool isDarkMode = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.getSecondaryBackground(isDarkMode),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.getBorder(isDarkMode)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: AppColors.brandYellow, size: AppIconSize.xs),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall(isDarkMode)),
        ],
      ),
    );
  }
}
