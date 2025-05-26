// lib/presentation/widgets/application_message_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';

import '../../bloc/matching/matching_bloc.dart';
import '../../bloc/matching/matching_event.dart';

class ApplicationMessageModal extends StatefulWidget {
  final String planId;

  const ApplicationMessageModal({super.key, required this.planId});

  @override
  State<ApplicationMessageModal> createState() =>
      _ApplicationMessageModalState();
}

class _ApplicationMessageModalState extends State<ApplicationMessageModal> {
  final TextEditingController _messageController = TextEditingController();
  final int _maxLength = 300;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(false),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '¿Quieres añadir un mensaje?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Agrega un mensaje para el creador de la propuesta (opcional)',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _messageController,
              maxLength: _maxLength,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cuéntale por qué te interesa este plan...',
                hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                counterStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withAlpha(26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.yellow.withAlpha(128)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final String message = _messageController.text.trim();
                      Navigator.pop(context);
                      context.read<MatchingBloc>().add(
                        MatchingEvent.applyToPlan(
                          widget.planId,
                          message.isNotEmpty ? message : null,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
