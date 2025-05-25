// libcore/blocs/applications_management/applications_management_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'applications_management_event.freezed.dart';

@freezed
abstract class ApplicationsManagementEvent with _$ApplicationsManagementEvent {
  // Inicializar y cargar las aplicaciones de un plan
  const factory ApplicationsManagementEvent.initialize(String planId) =
      _Initialize;

  // Cargar las aplicaciones de un plan (refresco)
  const factory ApplicationsManagementEvent.loadApplications(String planId) =
      _LoadApplications;

  // Cargar los perfiles de usuario de los aplicantes
  const factory ApplicationsManagementEvent.loadUserProfiles() =
      _LoadUserProfiles;

  // Aceptar una aplicación
  const factory ApplicationsManagementEvent.acceptApplication(
      String applicationId) = _AcceptApplication;

  // Rechazar una aplicación
  const factory ApplicationsManagementEvent.rejectApplication(
      String applicationId) = _RejectApplication;

  // Acción al filtrar aplicaciones
  const factory ApplicationsManagementEvent.filterApplications(
      String filterType) = _FilterApplications;

  // Buscar aplicaciones
  const factory ApplicationsManagementEvent.searchApplications(String query) =
      _SearchApplications;

  // Cambiar vista (lista/tarjetas)
  const factory ApplicationsManagementEvent.changeView(String viewType) =
      _ChangeView;
}
