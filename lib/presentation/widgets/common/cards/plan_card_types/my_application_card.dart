// lib/presentation/widgets/cards/plan_card_types/my_application_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card_utils.dart';

/// Tarjeta para mostrar aplicaciones del usuario a planes
class MyApplicationCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String category;
  final DateTime? date;
  final String planId;
  final String? applicationId;
  final String? applicationStatus;
  final String? applicationMessage;
  final DateTime? appliedAt;
  final Function(String)? onCancelApplication;

  const MyApplicationCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.category,
    required this.planId,
    this.date,
    this.applicationId,
    this.applicationStatus,
    this.applicationMessage,
    this.appliedAt,
    this.onCancelApplication,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el modo del tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    return Card(
      color: AppColors.getCardBackground(
        isDarkMode,
      ), // Usar color de tarjeta según tema
      elevation: AppElevation.card, // Usar elevación consistente
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.card,
        ), // Usar radio de borde constante
      ),
      shadowColor: isDarkMode
          ? AppColors.darkShadow
          : AppColors.lightShadow, // Sombra según tema
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Construye el encabezado con el estado y la fecha de aplicación
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.yellow.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.l),
          topRight: Radius.circular(AppRadius.l),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: PlanCardUtils.getStatusBackgroundColor(
                    applicationStatus ?? 'pending',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  PlanCardUtils.getStatusText(applicationStatus ?? 'pending'),
                  style: AppTypography.bodyMedium(
                    false,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(
            appliedAt != null
                ? 'Aplicaste el ${DateFormat('dd/MM/yyyy').format(appliedAt!)}'
                : 'Fecha de aplicación desconocida',
            style: AppTypography.bodyMedium(
              false,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido principal de la tarjeta
  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y categoría
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.heading2(false),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (category.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade800),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: AppSpacing.xs),

          // Fecha y ubicación
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.amber.shade800,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date!)
                    : 'Fecha no especificada',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.amber.shade800,
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  location.isNotEmpty ? location : 'Sin ubicación',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Mensaje del usuario
          if (applicationMessage != null && applicationMessage!.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: 16,
                        color: AppColors.brandYellow,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Tu mensaje:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s),
                  Text(
                    applicationMessage!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Construye los botones de acción
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón ver detalle del plan
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Ver Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade800,
                elevation: 1,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.blue.shade800),
                ),
              ),
              onPressed: () {
                context.push('/otherProposalDetail/$planId');
              },
            ),
          ),

          SizedBox(width: AppSpacing.xl),

          // Botón cancelar aplicación (solo si está pendiente)
          if (applicationStatus == 'pending' &&
              applicationId != null &&
              onCancelApplication != null)
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                label: const Text('Cancelar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showCancelDialog(context),
              ),
            ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de confirmación para cancelar la postulación
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 10),
            Text('Cancelar postulación'),
          ],
        ),
        content: const Text(
          '¿Estás seguro que deseas cancelar tu postulación a este plan?',
        ),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
            onPressed: () {
              Navigator.pop(context);
              if (applicationId != null && onCancelApplication != null) {
                onCancelApplication!(applicationId!);
              }
            },
          ),
        ],
      ),
    );
  }
}
