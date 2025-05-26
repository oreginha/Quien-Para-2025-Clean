// lib/presentation/widgets/cards/plan_card_types/my_plan_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/utils/network_resilient_image.dart';

/// Tarjeta para mostrar planes creados por el usuario
class MyPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime? date;
  final String planId;
  final Function(String, String)? onDeletePlan;

  const MyPlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.planId,
    this.date,
    this.onDeletePlan,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el modo del tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Formato de fecha
    String dateText = 'Fecha no disponible';
    if (date != null) {
      dateText = DateFormat('dd/MM/yyyy').format(date!);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(
          isDarkMode,
        ), // Usar color de tarjeta según el tema
        borderRadius: BorderRadius.circular(
          AppRadius.card,
        ), // Usar constante de bordes
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.darkShadow
                : AppColors.lightShadow, // Sombra según el tema
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            onTap: () => context.push(
              '/myPlanDetail/$planId',
              extra: <String, Object>{'isCreator': true},
            ),
            leading: _buildPlanImage(isDarkMode),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getTextPrimary(
                      isDarkMode,
                    ), // Color de texto según tema
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateText,
                  style: TextStyle(
                    color: AppColors.getTextSecondary(
                      isDarkMode,
                    ), // Color secundario según tema
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                description,
                style: TextStyle(
                  color: AppColors.getTextSecondary(
                    isDarkMode,
                  ), // Color secundario según tema
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: onDeletePlan != null ? _buildDeleteButton(context) : null,
          ),
        ],
      ),
    );
  }

  /// Construye la imagen del plan
  Widget _buildPlanImage(bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? AppColors.darkShadow
                  : AppColors.lightShadow, // Sombra según tema
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: imageUrl.isNotEmpty
            ? NetworkResilientImage(
                imageUrl: imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 60,
                  height: 60,
                  color: isDarkMode
                      ? AppColors.darkSecondaryBackground
                      : AppColors.lightSecondaryBackground, // Fondo según tema
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.getTextSecondary(
                      isDarkMode,
                    ), // Color secundario según tema
                  ),
                ),
              )
            : Container(
                width: 60,
                height: 60,
                color: isDarkMode
                    ? AppColors.darkSecondaryBackground
                    : AppColors.lightSecondaryBackground, // Fondo según tema
                child: Icon(
                  Icons.image,
                  color: AppColors.getTextSecondary(
                    isDarkMode,
                  ), // Color secundario según tema
                ),
              ),
      ),
    );
  }

  /// Construye el botón de eliminar plan
  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete_forever,
        color: AppColors.accentRed,
        size: 24,
      ), // Usar color definido en el sistema de temas
      onPressed: () => _showDeleteDialog(context),
    );
  }

  /// Muestra el diálogo de confirmación para eliminar el plan
  void _showDeleteDialog(BuildContext context) {
    if (onDeletePlan == null) return;

    // Obtener el modo del tema
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isDarkMode = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.getCardBackground(
            isDarkMode,
          ), // Fondo de tarjeta según tema
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
          title: Text(
            'Eliminar Propuesta',
            style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
          ),
          content: Text(
            '¿Estás seguro que deseas eliminar "$title"?',
            style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.closeScreen(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.closeScreen();
                onDeletePlan!(planId, title);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors
                    .accentRed, // Usar color de acento definido en el sistema
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
