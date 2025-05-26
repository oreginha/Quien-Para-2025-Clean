// lib/presentation/bloc/my_applications/my_applications_screen_bloc.dart
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/presentation/bloc/loading_cubit.dart';
import 'package:quien_para/presentation/bloc/my_applications/my_applications_cubit.dart';
import 'package:quien_para/presentation/widgets/common/bloc_loading_state_handler.dart';
import 'package:quien_para/presentation/widgets/common/feedback_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Versión refactorizada de MyApplicationsScreen que utiliza BLoC/Cubit
/// para manejar el estado en lugar de setState()
class MyApplicationsScreenBloc extends StatelessWidget {
  final String? userId;

  const MyApplicationsScreenBloc({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyApplicationsCubit(
        firestore: FirebaseFirestore.instance,
        userId: userId,
      ),
      child: const _MyApplicationsContent(),
    );
  }
}

class _MyApplicationsContent extends StatelessWidget {
  const _MyApplicationsContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyApplicationsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Aplicaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => cubit.loadApplications(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(context),
          Expanded(
            child:
                BlocBuilder<
                  MyApplicationsCubit,
                  LoadingState<MyApplicationsData>
                >(
                  builder: (context, state) {
                    return BlocLoadingStateHandler<MyApplicationsData>(
                      state: state,
                      onRefresh: () => cubit.loadApplications(),
                      emptyMessage: 'No has enviado ninguna aplicación todavía',
                      emptyIcon: Icons.inbox_outlined,
                      builder: (data) => _buildApplicationsList(context, data),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final cubit = context.read<MyApplicationsCubit>();

    return BlocBuilder<MyApplicationsCubit, LoadingState<MyApplicationsData>>(
      buildWhen: (previous, current) {
        // Solo reconstruir cuando cambia el filtro seleccionado o el estado
        final bool previousHasData = previous.map(
          loading: (_) => false,
          loaded: (_) => true,
          error: (_) => false,
          empty: (_) => false,
        );

        final bool currentHasData = current.map(
          loading: (_) => false,
          loaded: (_) => true,
          error: (_) => false,
          empty: (_) => false,
        );

        if (previousHasData && currentHasData) {
          return previous.map(
            loading: (_) => false,
            loaded: (prevLoaded) => current.map(
              loading: (_) => false,
              loaded: (currLoaded) =>
                  prevLoaded.data.selectedFilter !=
                  currLoaded.data.selectedFilter,
              error: (_) => false,
              empty: (_) => false,
            ),
            error: (_) => false,
            empty: (_) => false,
          );
        }
        return true;
      },
      builder: (context, state) {
        String? selectedFilter;

        state.map(
          loading: (_) => selectedFilter = null,
          loaded: (loaded) => selectedFilter = loaded.data.selectedFilter,
          error: (_) => selectedFilter = null,
          empty: (_) => selectedFilter = null,
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  label: 'Todas',
                  isSelected: selectedFilter == null,
                  onSelected: (_) => cubit.filterApplications(null),
                ),
                _buildFilterChip(
                  context,
                  label: 'Pendientes',
                  isSelected: selectedFilter == 'pending',
                  onSelected: (_) => cubit.filterApplications('pending'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Aceptadas',
                  isSelected: selectedFilter == 'accepted',
                  onSelected: (_) => cubit.filterApplications('accepted'),
                ),
                _buildFilterChip(
                  context,
                  label: 'Rechazadas',
                  isSelected: selectedFilter == 'rejected',
                  onSelected: (_) => cubit.filterApplications('rejected'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required void Function(bool) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: Theme.of(
          context,
        ).colorScheme.primary.withAlpha((0.1 * 255).round()),
        checkmarkColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildApplicationsList(BuildContext context, MyApplicationsData data) {
    final cubit = context.read<MyApplicationsCubit>();
    final applications = cubit.getFilteredApplications();

    if (applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withAlpha((0.38 * 255).round()),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay aplicaciones con el filtro seleccionado',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.loadApplications(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index];
          return _buildApplicationCard(context, application);
        },
      ),
    );
  }

  Widget _buildApplicationCard(
    BuildContext context,
    ApplicationEntity application,
  ) {
    final cubit = context.read<MyApplicationsCubit>();
    final plan = cubit.getPlanForApplication(application);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildApplicationHeader(context, application),
          if (plan != null) _buildPlanDetails(context, plan, application),
          if (plan == null && application.planId != null)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Cargando detalles del plan...'),
            ),
          _buildApplicationActions(context, application),
        ],
      ),
    );
  }

  Widget _buildApplicationHeader(
    BuildContext context,
    ApplicationEntity application,
  ) {
    final statusText = _getStatusText(application.status);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getStatusColor(
          application.status,
        ).withAlpha((0.1 * 255).round()),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aplicación #${application.id.substring(0, 8)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Enviada el ${_formatDate(application.appliedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(statusText),
            backgroundColor: _getStatusColor(
              application.status,
            ).withAlpha((0.2 * 255).round()),
            labelStyle: TextStyle(color: _getStatusColor(application.status)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetails(
    BuildContext context,
    PlanEntity plan,
    ApplicationEntity application,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan: ${plan.title}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            plan.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(plan.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  plan.location,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (application.message != null &&
              application.message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Tu mensaje:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              application.message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildApplicationActions(
    BuildContext context,
    ApplicationEntity application,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              // Implementar navegación a detalles del plan
              FeedbackMessage.show(
                context,
                message: 'Ver detalles del plan',
                type: FeedbackType.info,
              );
            },
            child: const Text('Ver Plan'),
          ),
          if (application.status == 'accepted')
            TextButton(
              onPressed: () {
                // Implementar navegación al chat
                FeedbackMessage.show(
                  context,
                  message: 'Ir al chat',
                  type: FeedbackType.info,
                );
              },
              child: const Text('Ir al Chat'),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptada';
      case 'rejected':
        return 'Rechazada';
      default:
        return 'Desconocido';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Fecha no disponible';
    return '${date.day}/${date.month}/${date.year}';
  }
}
