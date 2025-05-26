// lib/presentation/bloc/security/security_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/security/report_entity.dart';

part 'security_state.freezed.dart';

@freezed
class SecurityState with _$SecurityState {
  const factory SecurityState.initial() = SecurityInitial;

  const factory SecurityState.loading() = SecurityLoading;

  const factory SecurityState.reportCreated(ReportEntity report) =
      ReportCreated;

  const factory SecurityState.userBlocked() = UserBlocked;

  const factory SecurityState.pendingReportsLoaded(List<ReportEntity> reports) =
      PendingReportsLoaded;

  const factory SecurityState.userReportsLoaded(List<ReportEntity> reports) =
      UserReportsLoaded;

  const factory SecurityState.reportStatusUpdated(ReportEntity report) =
      ReportStatusUpdated;

  const factory SecurityState.error(String message) = SecurityError;
}
