// libcore/blocs/matching/matching_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'matching_event.freezed.dart';

@freezed
abstract class MatchingEvent with _$MatchingEvent {
  // Aplicar a un plan
  const factory MatchingEvent.applyToPlan(String planId, [String? message]) =
      _ApplyToPlan;

  // Cargar las aplicaciones de un usuario
  const factory MatchingEvent.loadUserApplications({String? userId}) =
      _LoadUserApplications;

  // Cargar las aplicaciones para un plan específico
  const factory MatchingEvent.loadPlanApplications(String planId) =
      _LoadPlanApplications;

  // Aceptar una aplicación
  const factory MatchingEvent.acceptApplication(String applicationId) =
      _AcceptApplication;

  // Rechazar una aplicación
  const factory MatchingEvent.rejectApplication(String applicationId) =
      _RejectApplication;

  // Cancelar una aplicación
  const factory MatchingEvent.cancelApplication(String applicationId) =
      _CancelApplication;

  // Refrescar las aplicaciones
  const factory MatchingEvent.refreshApplications() = _RefreshApplications;
}
