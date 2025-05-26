// lib/presentation/widgets/modals/report_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../core/theme/provider/theme_provider.dart';
import '../../../domain/entities/security/report_entity.dart';
import '../../bloc/security/security_bloc.dart';
import '../../bloc/security/security_event.dart';
import '../../bloc/security/security_state.dart';

class ReportDialog extends StatefulWidget {
  final String reportedUserId;
  final String? reportedPlanId;
  final ReportType type;
  final String? reportedUserName;

  const ReportDialog({
    super.key,
    required this.reportedUserId,
    this.reportedPlanId,
    required this.type,
    this.reportedUserName,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportReason? _selectedReason;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state is SecurityLoading) {
          setState(() => _isSubmitting = true);
        } else if (state is ReportCreated) {
          setState(() => _isSubmitting = false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reporte enviado exitosamente'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is SecurityError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.accentRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: AlertDialog(
        backgroundColor: AppColors.getCardBackground(isDarkMode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Row(
          children: [
            Icon(Icons.report_problem, color: AppColors.accentRed, size: 24),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                'Reportar ${widget.type == ReportType.user ? 'usuario' : 'plan'}',
                style: AppTypography.heading5(isDarkMode),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.reportedUserName != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.getSecondaryBackground(isDarkMode),
                      borderRadius: BorderRadius.circular(AppRadius.inputField),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppColors.brandYellow,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          'Reportando a: ${widget.reportedUserName}',
                          style: AppTypography.bodyMedium(
                            isDarkMode,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],

                Text(
                  'Selecciona el motivo del reporte:',
                  style: AppTypography.bodyLarge(
                    isDarkMode,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.m),

                // Lista de motivos
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.getBorder(isDarkMode)),
                    borderRadius: BorderRadius.circular(AppRadius.inputField),
                  ),
                  child: Column(
                    children: ReportReason.values.map((reason) {
                      final isSelected = _selectedReason == reason;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.brandYellow.withValues(alpha: 0.1)
                              : Colors.transparent,
                          border: reason != ReportReason.values.last
                              ? Border(
                                  bottom: BorderSide(
                                    color: AppColors.getBorder(isDarkMode),
                                    width: 0.5,
                                  ),
                                )
                              : null,
                        ),
                        child: RadioListTile<ReportReason>(
                          title: Text(
                            reason.displayName,
                            style: AppTypography.bodyMedium(isDarkMode)
                                .copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                          value: reason,
                          groupValue: _selectedReason,
                          onChanged: (value) =>
                              setState(() => _selectedReason = value),
                          activeColor: AppColors.brandYellow,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m,
                            vertical: AppSpacing.xs,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: AppSpacing.l),

                // Campo de descripción
                Text(
                  'Descripción adicional:',
                  style: AppTypography.bodyLarge(
                    isDarkMode,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.s),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 500,
                  style: AppTypography.bodyMedium(isDarkMode),
                  decoration: InputDecoration(
                    hintText: 'Describe el problema con más detalle...',
                    hintStyle: AppTypography.bodyMedium(
                      isDarkMode,
                    ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.inputField),
                      borderSide: BorderSide(
                        color: AppColors.getBorder(isDarkMode),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.inputField),
                      borderSide: BorderSide(
                        color: AppColors.brandYellow,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.inputField),
                      borderSide: BorderSide(
                        color: AppColors.getBorder(isDarkMode),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.getBackground(isDarkMode),
                  ),
                ),

                const SizedBox(height: AppSpacing.s),
                Text(
                  'Nota: Los reportes falsos pueden resultar en restricciones en tu cuenta.',
                  style: AppTypography.labelSmall(isDarkMode).copyWith(
                    color: AppColors.getTextSecondary(isDarkMode),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: AppTypography.bodyMedium(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
            ),
          ),
          ElevatedButton(
            onPressed: _canSubmit() && !_isSubmitting ? _submitReport : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Reportar',
                    style: AppTypography.bodyMedium(isDarkMode).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _selectedReason != null &&
        _descriptionController.text.trim().length >= 10;
  }

  void _submitReport() {
    if (!_canSubmit()) return;

    context.read<SecurityBloc>().add(
      SecurityEvent.createReport(
        reportedUserId: widget.reportedUserId,
        reportedPlanId: widget.reportedPlanId,
        type: widget.type,
        reason: _selectedReason!,
        description: _descriptionController.text.trim(),
      ),
    );
  }
}

// Función de conveniencia para mostrar el diálogo
Future<void> showReportDialog({
  required BuildContext context,
  required String reportedUserId,
  String? reportedPlanId,
  required ReportType type,
  String? reportedUserName,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ReportDialog(
        reportedUserId: reportedUserId,
        reportedPlanId: reportedPlanId,
        type: type,
        reportedUserName: reportedUserName,
      );
    },
  );
}
