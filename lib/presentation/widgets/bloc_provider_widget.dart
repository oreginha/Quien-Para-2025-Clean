// lib/presentation/widgets/bloc_provider_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/di/di.dart';

import '../bloc/feed/feed_bloc.dart';
import '../bloc/matching/matching_bloc.dart';
import '../bloc/plan/plan_bloc.dart';

/// Widget que proporciona BLoCs de manera consistente a través de la aplicación
/// Actúa como capa intermedia para proporcionar los BloCs correctos en diferentes contextos
class AppBlocProvider extends StatelessWidget {
  final Widget child;
  final String? feature;

  const AppBlocProvider({
    super.key,
    required this.child,
    this.feature,
  });

  @override
  Widget build(BuildContext context) {
    // Si se especifica una característica, proporcionar solo los BLoCs para esa característica
    if (feature != null) {
      return _getFeatureProviders(feature!, child);
    }

    // Si no se especifica característica, proporcionar BLoCs globales
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlanBloc>(
          create: (_) => sl<PlanBloc>(),
          lazy: true,
        ),
        BlocProvider<MatchingBloc>(
          create: (_) => sl<MatchingBloc>(),
          lazy: true,
        ),
        BlocProvider<FeedBloc>(
          create: (_) => sl<FeedBloc>(),
          lazy: true,
        ),
      ],
      child: child,
    );
  }

  /// Proporciona BLoCs para características específicas
  Widget _getFeatureProviders(String featureName, Widget child) {
    switch (featureName) {
      case 'plans':
        return BlocProvider<PlanBloc>(
          create: (_) => sl<PlanBloc>(),
          child: child,
        );
      case 'matching':
        return BlocProvider<MatchingBloc>(
          create: (_) => sl<MatchingBloc>(),
          child: child,
        );
      case 'feed':
        return BlocProvider<FeedBloc>(
          create: (_) => sl<FeedBloc>(),
          child: child,
        );
      default:
        return child;
    }
  }
}

/// Widget específico para la característica de planes
class PlanBlocProvider extends StatelessWidget {
  final Widget child;

  const PlanBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      feature: 'plans',
      child: child,
    );
  }
}

/// Widget específico para la característica de matching
class MatchingBlocProvider extends StatelessWidget {
  final Widget child;

  const MatchingBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      feature: 'matching',
      child: child,
    );
  }
}

/// Widget específico para la característica de feed
class FeedBlocProvider extends StatelessWidget {
  final Widget child;

  const FeedBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      feature: 'feed',
      child: child,
    );
  }
}
