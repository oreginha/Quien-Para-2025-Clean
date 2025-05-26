// lib/presentation/screens/Feed_Otros_Usuarios/widgets/plans_section_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'plan_card_widget.dart';

/// Widget que muestra la sección de planes del usuario
class PlansSectionWidget extends StatelessWidget {
  final String userId;
  final Color textPrimary;
  final Color secondaryBackground;
  final Color borderColor;
  final Color brandYellow;

  const PlansSectionWidget({
    super.key,
    required this.userId,
    required this.textPrimary,
    required this.secondaryBackground,
    required this.borderColor,
    required this.brandYellow,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder:
          (
            final BuildContext context,
            final AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
          ) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar los planes',
                  style: TextStyle(color: textPrimary),
                ),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: brandYellow),
              );
            }

            final List<DocumentSnapshot> plans = snapshot.data!.docs;

            if (plans.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Este usuario no tiene planes publicados',
                    style: TextStyle(color: textPrimary),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Planes publicados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  ...plans.map((final DocumentSnapshot document) {
                    final Map<String, dynamic> plan =
                        document.data() as Map<String, dynamic>;
                    plan['id'] = document.id;
                    return PlanCardWidget(
                      plan: plan,
                      secondaryBackground: secondaryBackground,
                      textPrimary: textPrimary,
                      borderColor: borderColor,
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
    );
  }
}
