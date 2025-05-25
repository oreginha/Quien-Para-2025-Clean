// lib/domain/repositories/report_repository.dart

import 'package:dartz/dartz.dart';
import '../../../presentation/widgets/errors/failures.dart';
import '../../entities/security/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportEntity>> createReport(ReportEntity report);

  Future<Either<Failure, List<ReportEntity>>> getRecentReports({
    required String reporterId,
    required String reportedUserId,
    required int hours,
  });

  Future<Either<Failure, List<ReportEntity>>> getPendingReports();

  Future<Either<Failure, ReportEntity>> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    String? moderatorId,
    String? moderatorNotes,
  });

  Future<Either<Failure, List<ReportEntity>>> getReportsByUser(String userId);
}
