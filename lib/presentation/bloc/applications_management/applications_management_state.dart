// libcore/blocs/applications_management/applications_management_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/application/application_entity.dart';

part 'applications_management_state.freezed.dart';

@freezed
abstract class ApplicationsManagementState with _$ApplicationsManagementState {
  // Estado inicial
  const factory ApplicationsManagementState.initial() = _Initial;

  // Estado de carga
  const factory ApplicationsManagementState.loading() = _Loading;

  // Estado cuando se han cargado las aplicaciones
  const factory ApplicationsManagementState.loaded({
    required List<ApplicationEntity> allApplications,
    required List<ApplicationEntity> filteredApplications,
    required Map<String, dynamic> userProfiles,
    required String currentFilter,
    required String currentSearch,
    required String viewType,
    @Default(false) bool isRefreshing,
    String? message,
  }) = _Loaded;

  // Estado de éxito de una acción (aceptar/rechazar)
  const factory ApplicationsManagementState.actionSuccess({
    required String message,
    required ApplicationEntity application,
  }) = _ActionSuccess;

  // Estado de error
  const factory ApplicationsManagementState.error(String message) = _Error;
}
