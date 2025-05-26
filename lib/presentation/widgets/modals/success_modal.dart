import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Tipo de modal de éxito
enum SuccessModalType {
  /// Modal simple sin efectos
  simple,

  /// Modal con efecto de confeti
  confetti,
}

/// Modal genérico para mostrar mensajes de éxito en la aplicación
///
/// Ofrece diferentes tipos (simple o con confeti) y es completamente personalizable
class SuccessModal extends StatefulWidget {
  /// Título del modal
  final String title;

  /// Mensaje descriptivo
  final String message;

  /// Texto del botón principal
  final String primaryButtonText;

  /// Acción al presionar el botón principal
  final VoidCallback? onPrimaryButtonPressed;

  /// Texto del botón secundario (opcional)
  final String? secondaryButtonText;

  /// Acción al presionar el botón secundario
  final VoidCallback? onSecondaryButtonPressed;

  /// Tipo de modal (simple o con confeti)
  final SuccessModalType type;

  /// Color de fondo del modal
  final Color darkPrimaryBackground;

  /// Ícono a mostrar (por defecto es check)
  final IconData icon;

  /// Color del ícono
  final Color iconColor;

  /// Color de fondo del círculo del ícono
  final Color iconBackgroundColor;

  const SuccessModal({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.type = SuccessModalType.simple,
    this.darkPrimaryBackground = const Color(0xFF2D2F53),
    this.icon = Icons.check,
    this.iconColor = Colors.black,
    this.iconBackgroundColor = Colors.yellow,
  });

  @override
  State<SuccessModal> createState() => _SuccessModalState();
}

class _SuccessModalState extends State<SuccessModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // Solo inicializar el controlador de confeti si es necesario
    if (widget.type == SuccessModalType.confetti) {
      _confettiController = ConfettiController(
        duration: const Duration(seconds: 2),
      );
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    // Solo descartar el controlador si fue inicializado
    if (widget.type == SuccessModalType.confetti) {
      _confettiController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        // Modal
        Dialog(
          backgroundColor: widget.darkPrimaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Ícono
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: widget.iconColor, size: 48),
                ),
                const SizedBox(height: 24),

                // Título
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Mensaje
                Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Botón primario
                ElevatedButton(
                  onPressed: () {
                    context.closeScreen();
                    if (widget.onPrimaryButtonPressed != null) {
                      widget.onPrimaryButtonPressed!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandYellow,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.primaryButtonText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Botón secundario (opcional)
                if (widget.secondaryButtonText != null) ...[
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.closeScreen();
                      if (widget.onSecondaryButtonPressed != null) {
                        widget.onSecondaryButtonPressed!();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: Text(widget.secondaryButtonText!),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Efecto de confeti (opcional)
        if (widget.type == SuccessModalType.confetti)
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -3.14 / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 50,
            gravity: 0.2,
          ),
      ],
    );
  }
}

/// Función auxiliar para mostrar un modal de éxito
Future<void> showSuccessModal({
  required BuildContext context,
  required String title,
  required String message,
  String primaryButtonText = '¡Vamos!',
  VoidCallback? onPrimaryButtonPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryButtonPressed,
  SuccessModalType type = SuccessModalType.simple,
  Color darkPrimaryBackground = const Color(0xFF2D2F53),
  IconData icon = Icons.check,
  Color iconColor = Colors.black,
  Color iconBackgroundColor = Colors.yellow,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => SuccessModal(
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      onPrimaryButtonPressed: onPrimaryButtonPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryButtonPressed: onSecondaryButtonPressed,
      type: type,
      darkPrimaryBackground: darkPrimaryBackground,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
    ),
  );
}
