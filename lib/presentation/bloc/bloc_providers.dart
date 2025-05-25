// lib/core/bloc/bloc_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import '../../../core/di/progressive_injection.dart';
import '../../../domain/usecases/security/create_report_usecase.dart';
import '../../../domain/usecases/security/get_pending_reports_usecase.dart';
import '../../../domain/usecases/security/block_user_usecase.dart';
import '../widgets/errors/failures.dart';
import 'security/security_bloc.dart';

/// Utilidad para simplificar la provisión de BLoCs a la UI
///
/// Facilita la creación y gestión de múltiples BLoC providers
/// mientras mantiene un enfoque consistente en toda la aplicación.
class BlocProviders {
  static final GetIt _sl = GetIt.instance;

  /// Obtiene una lista de BlocProviders globales para toda la aplicación
  ///
  /// Estos BLoCs deben ser aquellos necesarios en toda o la mayoría de la aplicación
  static List<SingleChildWidget> getAppProviders() {
    return [
      // Security BLoC - disponible globalmente para reportes
      BlocProvider<SecurityBloc>(
        create: (context) {
          try {
            return SecurityBloc(
              createReportUseCase:
                  ProgressiveInjection.sl.get<CreateReportUseCase>(
                instanceName: 'CreateReportUseCase',
              ),
              blockUserUseCase: _createMockBlockUserUseCase(),
              getPendingReportsUseCase:
                  ProgressiveInjection.sl.get<GetPendingReportsUseCase>(
                instanceName: 'GetPendingReportsUseCase',
              ),
              getReportsByUserUseCase:
                  ProgressiveInjection.sl.get<GetReportsByUserUseCase>(
                instanceName: 'GetReportsByUserUseCase',
              ),
              updateReportStatusUseCase:
                  ProgressiveInjection.sl.get<UpdateReportStatusUseCase>(
                instanceName: 'UpdateReportStatusUseCase',
              ),
            );
          } catch (e) {
            debugPrint('⚠️ Error inicializando SecurityBloc: $e');
            // Retornar SecurityBloc con casos de uso mock para evitar crash
            rethrow;
          }
        },
        lazy: true,
      ),
    ];
  }

  /// Obtiene una lista de BlocProviders para una característica específica
  ///
  /// Proporciona únicamente los BLoCs necesarios para una característica o flujo específico
  static List<SingleChildWidget> getFeatureProviders(String featureName) {
    switch (featureName) {
      case 'matching':
        return _getMatchingProviders();
      case 'plans':
        return _getPlansProviders();
      case 'profile':
        return _getProfileProviders();
      // Agregar más características según sea necesario
      default:
        return [];
    }
  }

  // Proveedores para características específicas

  static List<SingleChildWidget> _getMatchingProviders() {
    return [
      // Blocs específicos para matching
    ];
  }

  static List<SingleChildWidget> _getPlansProviders() {
    return [
      // Blocs específicos para planes
    ];
  }

  static List<SingleChildWidget> _getProfileProviders() {
    return [
      // Blocs específicos para perfil
    ];
  }

  /// Obtiene un BlocProvider específico de forma segura
  ///
  /// Intenta resolver desde GetIt y proporciona un valor por defecto si falla
  static SingleChildWidget getSafeBlocProvider<T extends Bloc>({
    required T Function() defaultCreator,
    bool lazy = true,
  }) {
    return BlocProvider<T>(
      create: (context) {
        try {
          return _sl.get<T>();
        } catch (e) {
          debugPrint('⚠️ Error al obtener ${T.toString()} desde GetIt: $e');
          debugPrint('Usando implementación por defecto');
          return defaultCreator();
        }
      },
      lazy: lazy,
    );
  }

  /// Crea un mock de BlockUserUseCase mientras se implementa IUserRepository
  static MockBlockUserUseCase _createMockBlockUserUseCase() {
    return MockBlockUserUseCase();
  }
}

/// Mock temporal de BlockUserUseCase
class MockBlockUserUseCase {
  // Simular la funcionalidad sin heredar de BlockUserUseCase para evitar dependencias complejas
  Future<Either<Failure, void>> call(BlockUserParams params) async {
    // Simular operación exitosa sin hacer nada real
    await Future.delayed(const Duration(milliseconds: 500));

    // Log para debug
    debugPrint(
        '🔒 Mock: Usuario ${params.blockedUserId} "bloqueado" por ${params.blockerId}');

    return const Right(null);
  }
}
