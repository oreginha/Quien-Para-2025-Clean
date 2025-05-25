// lib/presentation/bloc/security/security_event.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/security/report_entity.dart';

part 'security_event.freezed.dart';

@freezed
class SecurityEvent with _$SecurityEvent {
  const factory SecurityEvent.createReport({
    required String reportedUserId,
    String? reportedPlanId,
    required ReportType type,
    required ReportReason reason,
    required String description,
    Map<String, dynamic>? evidence,
  }) = CreateReportEvent;

  const factory SecurityEvent.blockUser({
    required String blockedUserId,
    ReportReason? reason,
    String? description,
  }) = BlockUserEvent;

  const factory SecurityEvent.loadPendingReports() = LoadPendingReportsEvent;

  const factory SecurityEvent.loadReportsByUser(String userId) = LoadReportsByUserEvent;

  const factory SecurityEvent.updateReportStatus({
    required String reportId,
    required ReportStatus status,
    String? moderatorNotes,
  }) = UpdateReportStatusEvent;
}
