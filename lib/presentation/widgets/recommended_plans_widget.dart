// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/di/di.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';

import 'package:quien_para/domain/entities/application/application_entity.dart';

import '../bloc/matching/matching_bloc.dart';
import '../bloc/matching/matching_event.dart';
import '../bloc/matching/matching_state.dart';

class RecommendedPlansWidget extends StatefulWidget {
  const RecommendedPlansWidget({super.key});

  @override
  State<RecommendedPlansWidget> createState() => _RecommendedPlansWidgetState();
}

class _RecommendedPlansWidgetState extends State<RecommendedPlansWidget> {
  late final MatchingBloc _matchingBloc;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _matchingBloc = sl<MatchingBloc>();
    _authRepository = sl<AuthRepository>();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    final String? currentUserId = _authRepository.getCurrentUserId();
    if (currentUserId != null) {
      _matchingBloc
          .add(MatchingEvent.loadUserApplications(userId: currentUserId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _matchingBloc,
      child: BlocBuilder<MatchingBloc, MatchingState>(
        builder: (BuildContext context, MatchingState state) {
          return state.when(
            initial: () => _buildEmptyState(),
            loading: () => _buildLoadingState(),
            userApplicationsLoaded: (List<ApplicationEntity> applications) {
              // Convertir las aplicaciones a un formato compatible con _buildLoadedState
              final List<Map<String, dynamic>> plans = applications
                  .map((ApplicationEntity app) => {
                        'planId': app.planId,
                        'title': app.planTitle ?? 'Sin título',
                        'description': app.message ?? 'Sin descripción',
                        'creatorName': app.applicantName ?? 'Usuario',
                        'creatorPhotoUrl': app.applicantPhotoUrl,
                        'category': 'General', // Valor por defecto
                        'location': '', // Valor por defecto
                        'score': 0.8, // Valor por defecto
                      })
                  .toList();
              return _buildLoadedState(context, plans);
            },
            planApplicationsLoaded: (_) => _buildEmptyState(),
            applicationActionSuccess: (_, __) => _buildEmptyState(),
            error: (message) => _buildErrorState(message),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 220,
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
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Planes recomendados para ti',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: plans.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> plan = plans[index];
              return _buildPlanCard(context, plan);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    return Container(
      width: 280,
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
              extra: <String, bool>{'isCreator': false},
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Encabezado con creador
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF46FAF7),
                  backgroundImage: plan['creatorPhotoUrl'] != null
                      ? NetworkImage(plan['creatorPhotoUrl'] as String)
                      : null,
                  child: plan['creatorPhotoUrl'] == null
                      ? const Icon(Icons.person, color: Color(0xFF1A1B2E))
                      : null,
                ),
                title: Text(
                  plan['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  plan['creatorName'] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF46FAF7).withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${(plan['score'] * 100).toInt()}% Match',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF46FAF7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Descripción
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  plan['description'] as String,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const Spacer(),

              // Pie con categoría y ubicación
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1B2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        plan['category']?.toUpperCase() as String,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (plan['location'] != null &&
                        (plan['location'] as String).isNotEmpty)
                      Row(
                        children: <Widget>[
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            plan['location'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 40, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Error al cargar recomendaciones',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _loadRecommendations,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF46FAF7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search_off, size: 40, color: Colors.white30),
            SizedBox(height: 16),
            Text(
              'No hay recomendaciones disponibles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Completa tu perfil y actividades para recibir recomendaciones personalizadas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // No cerramos el bloc aquí porque es proporcionado por sl
    super.dispose();
  }
}
