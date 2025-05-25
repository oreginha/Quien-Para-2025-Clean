// lib/presentation/widgets/state_converters.dart

import '../bloc/feed/feed_state.dart';
import '../bloc/matching/matching_state.dart';
import '../bloc/plan/plan_state.dart';
import '../widgets/loading/loading_state.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../domain/entities/application/application_entity.dart';

/// Extensiones para convertir entre estados específicos de BLoCs y LoadingState genérico
extension MatchingStateConverter on MatchingState {
  /// Convierte un MatchingState a LoadingState para aplicaciones de usuario
  LoadingState<List<ApplicationEntity>> toUserApplicationsLoadingState() {
    return map(
      initial: (_) => LoadingState.loading(),
      loading: (_) => LoadingState.loading(),
      userApplicationsLoaded: (state) =>
          LoadingState.loaded(state.applications),
      planApplicationsLoaded: (_) => LoadingState.loading(), // No aplica
      applicationActionSuccess: (_) =>
          LoadingState.loading(), // Requiere recarga
      error: (state) => LoadingState.error(state.message),
    );
  }

  /// Convierte un MatchingState a LoadingState para aplicaciones de plan
  LoadingState<List<ApplicationEntity>> toPlanApplicationsLoadingState() {
    return map(
      initial: (_) => LoadingState.loading(),
      loading: (_) => LoadingState.loading(),
      userApplicationsLoaded: (_) => LoadingState.loading(), // No aplica
      planApplicationsLoaded: (state) =>
          LoadingState.loaded(state.applications),
      applicationActionSuccess: (_) =>
          LoadingState.loading(), // Requiere recarga
      error: (state) => LoadingState.error(state.message),
    );
  }
}

/// Extensión para convertir FeedState a LoadingState
extension FeedStateConverter on FeedState {
  LoadingState<List<PlanEntity>> toLoadingState() {
    return map(
      initial: (_) => LoadingState.loading(),
      loading: (_) => LoadingState.loading(),
      refreshing: (_) => LoadingState.loading(),
      paginating: (_) => LoadingState.loading(),
      loaded: (state) => state.plans.isEmpty
          ? LoadingState.empty()
          : LoadingState.loaded(state.plans),
      filtered: (state) => state.plans.isEmpty
          ? LoadingState.empty()
          : LoadingState.loaded(state.plans),
      empty: (_) => LoadingState.empty(),
      error: (state) => LoadingState.error(state.message),
    );
  }
}

/// Extensión para convertir PlanState a LoadingState
extension PlanStateConverter on PlanState {
  LoadingState<PlanEntity> toLoadingState() {
    return maybeMap(
      initial: (_) => LoadingState.loading(),
      saving: (_) => LoadingState.loading(),
      loaded: (state) => LoadingState.loaded(state.plan),
      saved: (state) => LoadingState.loaded(state.plan),
      error: (state) => LoadingState.error(state.message),
      orElse: () => LoadingState.loading(),
    );
  }
}
