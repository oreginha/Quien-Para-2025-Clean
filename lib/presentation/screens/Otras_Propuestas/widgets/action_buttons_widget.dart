// lib/presentation/screens/Otras_Propuestas/widgets/action_buttons_widget.dart

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_theme.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';

import '../../../bloc/chat/chat_bloc.dart';

/// Widget que muestra los botones de acción para la pantalla de detalles de un plan
class ActionButtonsWidget extends StatelessWidget {
  final PlanEntity plan;
  final bool isDarkMode;
  final Function(String planId, [String? message]) onPostulationHandler;

  const ActionButtonsWidget({
    super.key,
    required this.plan,
    required this.isDarkMode,
    required this.onPostulationHandler,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('applicantId',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('planId', isEqualTo: plan.id)
          .snapshots(),
      builder: (context, applicationsSnapshot) {
        if (applicationsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool hasApplied =
            applicationsSnapshot.data?.docs.isNotEmpty ?? false;
        final String creatorName = 'Usuario';

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(isDarkMode),
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.getBorder(isDarkMode)
                    .withAlpha((0.2 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Te interesa este plan?',
                style: AppTypography.heading2(isDarkMode).copyWith(
                  color: AppColors.brandYellow,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              hasApplied
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppTheme.of(context)
                            .getColorWithAlpha(AppColors.success, 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.l),
                        border: Border.all(color: AppColors.success, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.success),
                          SizedBox(width: AppSpacing.xl),
                          Expanded(
                            child: Text(
                              'Ya te has postulado a este plan. El creador te notificará cuando acepte o rechace tu solicitud.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ActionButton(
                                text: '¡Quiero ir!',
                                onPressed: () {
                                  onPostulationHandler(plan.id);
                                },
                                icon: Icons.check_circle_outline,
                                fullWidth: true,
                                size: AppButtonSize.small,
                              ),
                            ),
                            SizedBox(width: AppSpacing.xl),
                            Expanded(
                              flex: 2,
                              child: ActionButton(
                                text: 'Contactar',
                                onPressed: () {
                                  // Iniciar chat con el creador
                                  final chatBloc = context.read<ChatBloc>();
                                  chatBloc.add(CreateConversation(
                                    participants: [
                                      FirebaseAuth.instance.currentUser!.uid,
                                      plan.creatorId
                                    ],
                                    initialMessage:
                                        'Hola, estoy interesado en tu plan "${plan.title}".',
                                  ));

                                  // Escuchar para la navegación
                                  chatBloc.stream.listen((state) {
                                    if (state is ConversationCreated) {
                                      context.push(
                                          '/chat/${state.conversationId}',
                                          extra: <String, String>{
                                            'receiverId': plan.creatorId,
                                            'receiverName': creatorName,
                                          });
                                    }
                                  });
                                },
                                icon: Icons.chat_bubble_outline,
                                fullWidth: true,
                                size: AppButtonSize.small,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xl),
                        Center(
                          child: Text(
                            '${applicationsSnapshot.data?.docs.length ?? 0} personas ya se han postulado',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}
