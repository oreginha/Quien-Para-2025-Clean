// ignore_for_file: always_specify_types, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:quien_para/core/di/di.dart';
import 'package:quien_para/domain/repositories/matching/matching_repository.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';

import '../bloc/matching/matching_bloc.dart';
import '../bloc/matching/matching_event.dart';
import '../bloc/matching/matching_state.dart';

class SimilarPlansWidget extends StatefulWidget {
  final String planId;

  const SimilarPlansWidget({
    super.key,
    required this.planId,
  });

  @override
  State<SimilarPlansWidget> createState() => _SimilarPlansWidgetState();
}

class _SimilarPlansWidgetState extends State<SimilarPlansWidget> {
  late final MatchingBloc _matchingBloc;
  late final MatchingRepository _matchingRepository;

  @override
  void initState() {
    super.initState();
    _matchingBloc = sl<MatchingBloc>();
    _matchingRepository = sl<MatchingRepository>();
    _loadSimilarPlans();
  }

  void _loadSimilarPlans() {
    // Opción 1: Seguir usando el evento existente en el bloc por ahora
    // (Esta opción mantiene la compatibilidad mientras se completa la migración)
    _matchingBloc.add(MatchingEvent.loadPlanApplications(widget.planId));

    // Opción 2: Usar directamente el repositorio (comentado por ahora)
    // Cuando quieras completar la migración, descomenta este código y comenta el anterior
    // También será necesario actualizar el bloc para manejar el nuevo evento
    /*
    // Usar el repositorio directamente
    _matchingRepository.findSimilarPlans(widget.planId).then((similarPlans) {
      // Aquí tendrías que actualizar el estado del widget 
      // o crear un nuevo evento en el bloc para manejar los planes similares
      _matchingBloc.add(MatchingEvent.similarPlansLoaded(similarPlans));
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _matchingBloc,
      child: BlocBuilder<MatchingBloc, MatchingState>(
        builder: (context, state) {
          // Usando el método when para manejar los estados generados por Freezed
          return state.when(
            initial: () => _buildEmptyState(),
            loading: () => _buildLoadingState(),
            userApplicationsLoaded: (applications) =>
                _buildEmptyState(), // No aplica
            planApplicationsLoaded: (applications) {
              // Adaptación: convertir las aplicaciones en una lista de planes similares
              // Esto es un workaround hasta que se implemente correctamente
              final mockPlans = _mockSimilarPlansFromApplications(applications);
              return _buildLoadedState(context, mockPlans);
            },
            applicationActionSuccess: (message, application) =>
                _buildEmptyState(), // No aplica
            error: (message) => _buildErrorState(message),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoadedState(
      BuildContext context, List<Map<String, dynamic>> plans) {
    if (plans.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Planes similares',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return _buildPlanCard(context, plan);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        color: const Color(0xFF252840),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navegar al detalle del plan
            context.push(
              '/otherProposalDetail/${plan['planId']}',
              extra: {'isCreator': false},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y creador
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF46FAF7),
                      backgroundImage: plan['creatorPhotoUrl'] != null
                          ? NetworkImage(plan['creatorPhotoUrl'] as String)
                          : null,
                      child: plan['creatorPhotoUrl'] == null
                          ? const Icon(Icons.person,
                              size: 14, color: Color(0xFF1A1B2E))
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            plan['creatorName'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF46FAF7)
                            .withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(plan['similarity'] * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF46FAF7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Descripción
                Expanded(
                  child: Text(
                    plan['description'] as String,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 24, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              'Error: $message',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            TextButton(
              onPressed: _loadSimilarPlans,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF46FAF7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    // Si no hay planes similares, no mostramos nada
    return const SizedBox.shrink();
  }

  // Esta función convierte ApplicationEntity en planes similares (solución temporal)
  List<Map<String, dynamic>> _mockSimilarPlansFromApplications(
      List<ApplicationEntity> applications) {
    // Convertir aplicaciones a planes "similares" (esto es una solución temporal)
    // En la implementación real, deberías tener una respuesta del backend con planes realmente similares
    final List<Map<String, dynamic>> mockPlans = [];

    // Limitamos a máximo 5 resultados para el widget
    final maxResults = applications.length > 5 ? 5 : applications.length;

    for (int i = 0; i < maxResults; i++) {
      final app = applications[i];

      // Construir un plan falso basado en la aplicación
      // En la implementación real, esto vendría del backend
      mockPlans.add({
        'planId': app.planId,
        'title': 'Plan relacionado ${i + 1}',
        'description': app.message ?? 'Sin descripción disponible',
        'creatorName': 'Usuario ${app.applicantId.substring(0, 5)}',
        'creatorPhotoUrl': null, // No tenemos la foto en este punto
        'similarity': 0.7 - (i * 0.1), // Similaridad decreciente para simular
      });
    }

    return mockPlans;
  }
}
