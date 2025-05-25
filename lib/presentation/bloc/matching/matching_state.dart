// libcore/blocs/matching/matching_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/application/application_entity.dart';

part 'matching_state.freezed.dart';

@freezed
abstract class MatchingState with _$MatchingState {
  // Estado inicial
  const factory MatchingState.initial() = _Initial;

  // Estado de carga
  const factory MatchingState.loading() = _Loading;

  // Aplicaciones de un usuario cargadas
  const factory MatchingState.userApplicationsLoaded(
    List<ApplicationEntity> applications,
  ) = _UserApplicationsLoaded;

  // Aplicaciones para un plan cargadas
  const factory MatchingState.planApplicationsLoaded(
    List<ApplicationEntity> applications,
  ) = _PlanApplicationsLoaded;

  // Una acción de aplicación se completó con éxito (aceptar, rechazar, cancelar)
  const factory MatchingState.applicationActionSuccess(
    String message,
    ApplicationEntity application,
  ) = _ApplicationActionSuccess;

  // Estado de error
  const factory MatchingState.error(String message) = _Error;
}
