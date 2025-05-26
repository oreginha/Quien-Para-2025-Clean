//lib/presentation/widgets/application_success_modal.dart
// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Modal que se muestra cuando una aplicación es aceptada (para el aplicante)
void showApplicationAcceptedModal({
  required final BuildContext context,
  final String planTitle = '',
  final VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (final BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF2D2F53),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Felicidades!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                planTitle.isNotEmpty
                    ? 'Tu aplicación para "$planTitle" ha sido aceptada. ¡Ya puedes participar en este plan!'
                    : 'Tu aplicación ha sido aceptada. ¡Ya puedes participar en este plan!',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.closeScreen();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Modal que se muestra cuando un creador acepta a un aplicante
void showApplicationConfirmedModal({
  required final BuildContext context,
  final String applicantName = '',
  final String planTitle = '',
  final VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (final BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF2D2F53),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Participante confirmado!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _buildConfirmationMessage(applicantName, planTitle),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.closeScreen();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Modal que se muestra cuando una aplicación es rechazada (para el aplicante)
void showApplicationRejectedModal({
  required final BuildContext context,
  final String planTitle = '',
  final VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (final BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF2D2F53),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Aplicación no aceptada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                planTitle.isNotEmpty
                    ? 'Tu aplicación para "$planTitle" no ha sido aceptada. ¡No te desanimes, hay muchos otros planes disponibles!'
                    : 'Tu aplicación no ha sido aceptada. ¡No te desanimes, hay muchos otros planes disponibles!',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.closeScreen();
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Construye un mensaje personalizado para la confirmación de aplicación
String _buildConfirmationMessage(String applicantName, String planTitle) {
  if (applicantName.isNotEmpty && planTitle.isNotEmpty) {
    return 'Has confirmado a $applicantName para tu plan "$planTitle". ¡Ya pueden coordinar los detalles!';
  } else if (applicantName.isNotEmpty) {
    return 'Has confirmado a $applicantName para tu plan. ¡Ya pueden coordinar los detalles!';
  } else if (planTitle.isNotEmpty) {
    return 'Has confirmado a un participante para tu plan "$planTitle". ¡Ya pueden coordinar los detalles!';
  } else {
    return 'Has confirmado a un participante para tu plan. ¡Ya pueden coordinar los detalles!';
  }
}
