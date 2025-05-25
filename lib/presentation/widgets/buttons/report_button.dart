// lib/presentation/widgets/buttons/report_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../domain/entities/security/report_entity.dart';
import '../modals/report_dialog.dart';

class ReportButton extends StatelessWidget {
  final String reportedUserId;
  final String? reportedPlanId;
  final ReportType type;
  final String? reportedUserName;
  final ReportButtonStyle style;
  final VoidCallback? onReported;

  const ReportButton({
    super.key,
    required this.reportedUserId,
    this.reportedPlanId,
    required this.type,
    this.reportedUserName,
    this.style = ReportButtonStyle.icon,
    this.onReported,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    switch (style) {
      case ReportButtonStyle.icon:
        return _buildIconButton(context, isDarkMode);
      case ReportButtonStyle.text:
        return _buildTextButton(context, isDarkMode);
      case ReportButtonStyle.elevated:
        return _buildElevatedButton(context, isDarkMode);
      case ReportButtonStyle.menuItem:
        return _buildMenuItem(context, isDarkMode);
    }
  }

  Widget _buildIconButton(BuildContext context, bool isDarkMode) {
    return IconButton(
      onPressed: () => _showReportDialog(context),
      icon: Icon(
        Icons.report_outlined,
        color: AppColors.getTextSecondary(isDarkMode),
      ),
      tooltip: 'Reportar ${type == ReportType.user ? 'usuario' : 'plan'}',
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDarkMode) {
    return TextButton.icon(
      onPressed: () => _showReportDialog(context),
      icon: Icon(
        Icons.report_outlined,
        size: 18,
        color: AppColors.accentRed.withValues(alpha: 0.8),
      ),
      label: Text(
        'Reportar',
        style: AppTypography.bodyMedium(isDarkMode).copyWith(
          color: AppColors.accentRed.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context, bool isDarkMode) {
    return ElevatedButton.icon(
      onPressed: () => _showReportDialog(context),
      icon: const Icon(
        Icons.report_outlined,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        'Reportar',
        style: AppTypography.bodyMedium(isDarkMode).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, bool isDarkMode) {
    return ListTile(
      leading: Icon(
        Icons.report_outlined,
        color: AppColors.accentRed,
        size: 20,
      ),
      title: Text(
        'Reportar ${type == ReportType.user ? 'usuario' : 'plan'}',
        style: AppTypography.bodyMedium(isDarkMode).copyWith(
          color: AppColors.accentRed,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(); // Cerrar el menú
        _showReportDialog(context);
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
    );
  }

  Future<void> _showReportDialog(BuildContext context) async {
    await showReportDialog(
      context: context,
      reportedUserId: reportedUserId,
      reportedPlanId: reportedPlanId,
      type: type,
      reportedUserName: reportedUserName,
    );

    // Llamar callback si se proporcionó
    onReported?.call();
  }
}

enum ReportButtonStyle {
  icon,
  text,
  elevated,
  menuItem,
}

// Widget para mostrar opciones de seguridad en un bottom sheet
class SecurityBottomSheet extends StatelessWidget {
  final String targetUserId;
  final String? targetPlanId;
  final ReportType type;
  final String? targetUserName;
  final VoidCallback? onBlocked;
  final VoidCallback? onReported;

  const SecurityBottomSheet({
    super.key,
    required this.targetUserId,
    this.targetPlanId,
    required this.type,
    this.targetUserName,
    this.onBlocked,
    this.onReported,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.s),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.getTextSecondary(isDarkMode),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.brandYellow,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    'Opciones de seguridad',
                    style: AppTypography.heading5(isDarkMode),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
              ],
            ),
          ),

          // Options
          ReportButton(
            reportedUserId: targetUserId,
            reportedPlanId: targetPlanId,
            type: type,
            reportedUserName: targetUserName,
            style: ReportButtonStyle.menuItem,
            onReported: () {
              Navigator.of(context).pop();
              onReported?.call();
            },
          ),

          if (type == ReportType.user) ...[
            Divider(
              color: AppColors.getBorder(isDarkMode),
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.block,
                color: AppColors.accentRed,
                size: 20,
              ),
              title: Text(
                'Bloquear usuario',
                style: AppTypography.bodyMedium(isDarkMode).copyWith(
                  color: AppColors.accentRed,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showBlockConfirmation(context);
              },
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.xs,
              ),
            ),
          ],

          SizedBox(
              height: MediaQuery.of(context).padding.bottom + AppSpacing.m),
        ],
      ),
    );
  }

  void _showBlockConfirmation(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.getCardBackground(isDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          title: Row(
            children: [
              Icon(
                Icons.block,
                color: AppColors.accentRed,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Bloquear usuario',
                style: AppTypography.heading5(isDarkMode),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                targetUserName != null
                    ? '¿Estás seguro de que quieres bloquear a $targetUserName?'
                    : '¿Estás seguro de que quieres bloquear a este usuario?',
                style: AppTypography.bodyMedium(isDarkMode),
              ),
              const SizedBox(height: AppSpacing.m),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Text(
                  'Al bloquear este usuario:\n• No podrás ver sus planes\n• No podrá contactarte\n• No aparecerá en búsquedas',
                  style: AppTypography.labelMedium(isDarkMode).copyWith(
                    color: AppColors.accentRed,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: AppTypography.bodyMedium(isDarkMode).copyWith(
                  color: AppColors.getTextSecondary(isDarkMode),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implementar bloqueo a través del SecurityBloc
                onBlocked?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Bloquear'),
            ),
          ],
        );
      },
    );
  }
}

// Función para mostrar el bottom sheet de seguridad
Future<void> showSecurityBottomSheet({
  required BuildContext context,
  required String targetUserId,
  String? targetPlanId,
  required ReportType type,
  String? targetUserName,
  VoidCallback? onBlocked,
  VoidCallback? onReported,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return SecurityBottomSheet(
        targetUserId: targetUserId,
        targetPlanId: targetPlanId,
        type: type,
        targetUserName: targetUserName,
        onBlocked: onBlocked,
        onReported: onReported,
      );
    },
  );
}
