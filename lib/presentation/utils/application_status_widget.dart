// lib/presentation/widgets/application_status_widget.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/presentation/bloc/applications_management/applications_management_bloc.dart';
import 'package:quien_para/presentation/bloc/applications_management/applications_management_event.dart';
import 'package:quien_para/presentation/bloc/matching/matching_bloc.dart';
import 'package:quien_para/presentation/bloc/matching/matching_event.dart';
import '../../domain/entities/application/application_entity.dart';
import '../../core/theme/app_theme.dart';

class ApplicationStatusWidget extends StatelessWidget {
  final ApplicationEntity application;
  final bool isCreator;

  const ApplicationStatusWidget({
    super.key,
    required this.application,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      decoration: BoxDecoration(
        color: _getStatusBackgroundColor(application.status),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: _getStatusColor(application.status),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(application.status),
                      color: _getStatusColor(application.status),
                      size: 24,
                    ),
                    SizedBox(width: AppSpacing.l),
                    Text(
                      'Estado: ${_getStatusText(application.status)}',
                      style: AppTypography.heading2(false).copyWith(
                        color: _getStatusColor(application.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (application.status == 'pending' && isCreator)
                  Row(
                    children: [
                      // Botón de aceptar
                      ElevatedButton.icon(
                        onPressed: () => _showAcceptConfirmation(context),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Aceptar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF27AE60,
                          ), // accentGreen
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.l,
                            vertical: AppSpacing.s,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.l),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.l),
                      // Botón de rechazar
                      OutlinedButton.icon(
                        onPressed: () => _showRejectConfirmation(context),
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text('Rechazar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.brandYellow,
                          side: BorderSide(color: AppColors.brandYellow),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.l,
                            vertical: AppSpacing.xs,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.l),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (application.status == 'pending' && !isCreator)
                  OutlinedButton.icon(
                    onPressed: () => _showCancelConfirmation(context),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Cancelar aplicación'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.brandYellow,
                      side: BorderSide(color: AppColors.brandYellow),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.xs,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.l),
                      ),
                    ),
                  ),
              ],
            ),
            if (application.message != null &&
                application.message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Divider(color: Theme.of(context).dividerColor, height: 1),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mensaje del aplicante:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightTextPrimary.withAlpha(
                        (255 * AppTheme.of(context).mediumEmphasisOpacity)
                            .round(),
                      ),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(AppRadius.l),
                ),
                child: Text(
                  application.message!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightTextPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).dividerColor,
                    ),
                    const SizedBox(width: 4), // Equivalente a spacingXS
                    Text(
                      'Aplicado el ${_formatDate(application.appliedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).dividerColor,
                          ),
                    ),
                  ],
                ),
                if (application.processedAt != null) ...[
                  Text(
                    'Procesado el ${_formatDate(application.processedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).dividerColor,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptado';
      case 'rejected':
        return 'Rechazado';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF39C12); // accentYellow from AppColors
      case 'accepted':
        return const Color(0xFF27AE60); // accentGreen from AppColors
      case 'rejected':
        return AppColors.brandYellow; // Ya definido en AppTheme
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(
          0xFFF39C12,
        ).withAlpha((0.15 * 255).round()); // accentYellow
      case 'accepted':
        return const Color(
          0xFF27AE60,
        ).withAlpha((0.15 * 255).round()); // accentGreen
      case 'rejected':
        return AppColors.brandYellow.withAlpha((0.15 * 255).round());
      default:
        return Colors.grey.withAlpha((0.15 * 255).round());
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleAccept(BuildContext context) {
    // Intentar usar el ApplicationsManagementBloc si está disponible
    try {
      context.read<ApplicationsManagementBloc>().add(
            ApplicationsManagementEvent.acceptApplication(application.id),
          );
    } catch (e) {
      // Si no está disponible, usar el MatchingBloc como fallback
      context.read<MatchingBloc>().add(
            MatchingEvent.acceptApplication(application.id),
          );
    }
  }

  void _handleReject(BuildContext context) {
    // Intentar usar el ApplicationsManagementBloc si está disponible
    try {
      context.read<ApplicationsManagementBloc>().add(
            ApplicationsManagementEvent.rejectApplication(application.id),
          );
    } catch (e) {
      // Si no está disponible, usar el MatchingBloc como fallback
      context.read<MatchingBloc>().add(
            MatchingEvent.rejectApplication(application.id),
          );
    }
  }

  void _handleCancel(BuildContext context) {
    // Para cancelar siempre usar el MatchingBloc, ya que esta funcionalidad
    // es específica del usuario que hace la aplicación, no del gestor
    context.read<MatchingBloc>().add(
          MatchingEvent.cancelApplication(application.id),
        );
  }

  void _showAcceptConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Aceptar aplicación', style: AppTypography.heading2(false)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de aceptar a este participante?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.success),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Se le notificará al usuario y se creará un chat para que puedan coordinar.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ThemeUtils.background,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleAccept(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showRejectConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Rechazar aplicación',
          style: AppTypography.heading2(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de rechazar a este participante?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60).withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: const Color(0xFF27AE60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.brandYellow),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Se le notificará al usuario que su solicitud ha sido rechazada.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ThemeUtils.background,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleReject(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          'Cancelar aplicación',
          style: AppTypography.heading2(false),
        ),
        content: Text(
          '¿Estás seguro de cancelar tu solicitud para participar en este plan?',
          style: ThemeUtils.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleCancel(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}
