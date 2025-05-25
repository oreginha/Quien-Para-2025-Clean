// lib/data/repositories/security/report_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/security/report_entity.dart';
import '../../../domain/repositories/report/report_repository.dart';
import '../../../presentation/widgets/errors/failures.dart';

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseFirestore _firestore;

  const ReportRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, ReportEntity>> createReport(
      ReportEntity report) async {
    try {
      final reportData = {
        'reporterId': report.reporterId,
        'reportedUserId': report.reportedUserId,
        'reportedPlanId': report.reportedPlanId,
        'type': report.type.name,
        'reason': report.reason.name,
        'description': report.description,
        'createdAt': Timestamp.fromDate(report.createdAt),
        'status': report.status.name,
        'moderatorId': report.moderatorId,
        'moderatorNotes': report.moderatorNotes,
        'resolvedAt': report.resolvedAt != null
            ? Timestamp.fromDate(report.resolvedAt!)
            : null,
        'evidence': report.evidence,
      };

      await _firestore.collection('reports').doc(report.id).set(reportData);

      // Enviar notificación a moderadores
      await _notifyModerators(report);

      return Right(report);
    } catch (e) {
      return Left(ServerFailure(e.toString(), originalError: "null"));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getRecentReports({
    required String reporterId,
    required String reportedUserId,
    required int hours,
  }) async {
    try {
      final cutoffTime = DateTime.now().subtract(Duration(hours: hours));

      final querySnapshot = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: reporterId)
          .where('reportedUserId', isEqualTo: reportedUserId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffTime))
          .get();

      final reports =
          querySnapshot.docs.map((doc) => _mapDocumentToReport(doc)).toList();

      return Right(reports);
    } catch (e) {
      return Left(ServerFailure(e.toString(), originalError: "null"));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getPendingReports() async {
    try {
      final querySnapshot = await _firestore
          .collection('reports')
          .where('status', isEqualTo: ReportStatus.pending.name)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final reports =
          querySnapshot.docs.map((doc) => _mapDocumentToReport(doc)).toList();

      return Right(reports);
    } catch (e) {
      return Left(ServerFailure(e.toString(), originalError: "null"));
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    String? moderatorId,
    String? moderatorNotes,
  }) async {
    try {
      final updateData = {
        'status': status.name,
        'resolvedAt': Timestamp.fromDate(DateTime.now()),
        if (moderatorId != null) 'moderatorId': moderatorId,
        if (moderatorNotes != null) 'moderatorNotes': moderatorNotes,
      };

      await _firestore.collection('reports').doc(reportId).update(updateData);

      final doc = await _firestore.collection('reports').doc(reportId).get();
      final report = _mapDocumentToReport(doc);

      return Right(report);
    } catch (e) {
      return Left(ServerFailure(e.toString(), originalError: "null"));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReportsByUser(
      String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('reports')
          .where('reportedUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final reports =
          querySnapshot.docs.map((doc) => _mapDocumentToReport(doc)).toList();

      return Right(reports);
    } catch (e) {
      return Left(ServerFailure(e.toString(), originalError: "null"));
    }
  }

  Future<void> _notifyModerators(ReportEntity report) async {
    try {
      // Crear notificación para moderadores
      await _firestore.collection('moderation_queue').add({
        'reportId': report.id,
        'type': 'new_report',
        'priority': report.reason.priority,
        'createdAt': FieldValue.serverTimestamp(),
        'reportData': {
          'reporterId': report.reporterId,
          'reportedUserId': report.reportedUserId,
          'type': report.type.name,
          'reason': report.reason.name,
        },
      });
    } catch (e) {
      // Log error but don't fail the main operation
      if (kDebugMode) {
        print('Error notifying moderators: $e');
      }
    }
  }

  ReportEntity _mapDocumentToReport(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReportEntity(
      id: doc.id,
      reporterId: data['reporterId'] as String,
      reportedUserId: data['reportedUserId'] as String,
      reportedPlanId: data['reportedPlanId'] as String?,
      type: ReportType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ReportType.user,
      ),
      reason: ReportReason.values.firstWhere(
        (e) => e.name == data['reason'],
        orElse: () => ReportReason.other,
      ),
      description: data['description'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: ReportStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ReportStatus.pending,
      ),
      moderatorId: data['moderatorId'] as String?,
      moderatorNotes: data['moderatorNotes'] as String?,
      resolvedAt: data['resolvedAt'] != null
          ? (data['resolvedAt'] as Timestamp).toDate()
          : null,
      evidence: data['evidence'] as Map<String, dynamic>?,
    );
  }
}
