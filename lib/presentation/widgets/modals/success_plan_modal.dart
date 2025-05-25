// lib/presentation/screens/create_proposal/widgets/success_plan_modal.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

import '../../bloc/plan/plan_bloc.dart';
// lib/presentation/widgets/success_plan_modal.dart

class SuccessPlanModal extends StatefulWidget {
  final String planTitle;

  const SuccessPlanModal({
    super.key,
    required this.planTitle,
  });

  @override
  State<SuccessPlanModal> createState() => _SuccessPlanModalState();
}

class _SuccessPlanModalState extends State<SuccessPlanModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  '¡Felicitaciones!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu plan "${widget.planTitle}" ha sido creado exitosamente',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    context.read<PlanBloc>().close();
                    context.pushReplacement(AppRouter.createProposal);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text(
                    'Crear otro plan',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () =>
                      context.pushReplacement(AppRouter.proposalsScreen),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text('Ver planes disponibles'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
