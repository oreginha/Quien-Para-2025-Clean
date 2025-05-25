// lib/presentation/widgets/success_plan_modal2.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

class SuccessPlanModal extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;

  const SuccessPlanModal({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
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
  Widget build(BuildContext context) {
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
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    context.closeScreen();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(color: Colors.black),
                  ),
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
