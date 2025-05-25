// lib/domain/usecases/security/get_pending_reports_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../presentation/widgets/errors/failures.dart';
import '../../entities/security/report_entity.dart';
import '../../repositories/report/report_repository.dart';

class GetPendingReportsUseCase {
  final ReportRepository _repository;

  const GetPendingReportsUseCase(this._repository);

  Future<Either<Failure, List<ReportEntity>>> call() async {
    return await _repository.getPendingReports();
  }
}

class GetReportsByUserUseCase {
  final ReportRepository _repository;

  const GetReportsByUserUseCase(this._repository);

  Future<Either<Failure, List<ReportEntity>>> call(String userId) async {
    return await _repository.getReportsByUser(userId);
  }
}

class UpdateReportStatusUseCase {
  final ReportRepository _repository;

  const UpdateReportStatusUseCase(this._repository);

  Future<Either<Failure, ReportEntity>> call(
      UpdateReportStatusParams params) async {
    return await _repository.updateReportStatus(
      reportId: params.reportId,
      status: params.status,
      moderatorId: params.moderatorId,
      moderatorNotes: params.moderatorNotes,
    );
  }
}

class UpdateReportStatusParams {
  final String reportId;
  final ReportStatus status;
  final String? moderatorId;
  final String? moderatorNotes;

  const UpdateReportStatusParams({
    required this.reportId,
    required this.status,
    this.moderatorId,
    this.moderatorNotes,
  });
}
