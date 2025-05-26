// lib/domain/usecases/security/create_report_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../presentation/widgets/errors/failures.dart';
import '../../entities/security/report_entity.dart';
import '../../repositories/report/report_repository.dart';

class CreateReportUseCase {
  final ReportRepository _repository;

  const CreateReportUseCase(this._repository);

  Future<Either<Failure, ReportEntity>> call(CreateReportParams params) async {
    // Validaciones
    if (params.reporterId == params.reportedUserId) {
      return Left(ValidationFailure('No puedes reportarte a ti mismo'));
    }

    if (params.description.trim().length < 10) {
      return Left(
        ValidationFailure('La descripción debe tener al menos 10 caracteres'),
      );
    }

    // Verificar si ya existe un reporte similar reciente
    final existingReports = await _repository.getRecentReports(
      reporterId: params.reporterId,
      reportedUserId: params.reportedUserId,
      hours: 24,
    );

    return existingReports.fold((failure) => Left(failure), (reports) async {
      if (reports.isNotEmpty) {
        return Left(
          ValidationFailure('Ya has reportado a este usuario recientemente'),
        );
      }

      // Crear el reporte
      final report = ReportEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        reporterId: params.reporterId,
        reportedUserId: params.reportedUserId,
        reportedPlanId: params.reportedPlanId,
        type: params.type,
        reason: params.reason,
        description: params.description,
        createdAt: DateTime.now(),
        evidence: params.evidence,
      );

      return await _repository.createReport(report);
    });
  }
}

class CreateReportParams {
  final String reporterId;
  final String reportedUserId;
  final String? reportedPlanId;
  final ReportType type;
  final ReportReason reason;
  final String description;
  final Map<String, dynamic>? evidence;

  const CreateReportParams({
    required this.reporterId,
    required this.reportedUserId,
    this.reportedPlanId,
    required this.type,
    required this.reason,
    required this.description,
    this.evidence,
  });
}
