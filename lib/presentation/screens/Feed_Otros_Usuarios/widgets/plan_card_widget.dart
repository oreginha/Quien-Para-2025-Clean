// lib/presentation/screens/Feed_Otros_Usuarios/widgets/plan_card_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget que muestra una tarjeta de plan
class PlanCardWidget extends StatelessWidget {
  final Map<String, dynamic> plan;
  final Color secondaryBackground;
  final Color textPrimary;
  final Color borderColor;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.secondaryBackground,
    required this.textPrimary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: secondaryBackground,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => context.push("/otherProposalDetail/${plan['id']}"),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            (plan['imageUrl'] as String?) ?? '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder:
                (
                  final BuildContext context,
                  final Object error,
                  final StackTrace? stackTrace,
                ) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: borderColor,
                    child: Icon(
                      Icons.image_not_supported,
                      color: textPrimary.withValues(alpha: 0.5),
                    ),
                  );
                },
          ),
        ),
        title: Text(
          plan['title']?.toString() ?? 'Sin título',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        subtitle: Text(
          plan['description']?.toString() ?? 'Sin descripción',
          style: TextStyle(color: textPrimary.withValues(alpha: 0.7)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
