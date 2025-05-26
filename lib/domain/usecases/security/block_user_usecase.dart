// lib/domain/usecases/security/block_user_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../presentation/widgets/errors/failures.dart';
import '../../entities/security/report_entity.dart';
import '../../repositories/report/report_repository.dart';
import '../../repositories/user/user_repository_interface.dart';

class BlockUserUseCase {
  final IUserRepository _userRepository;
  final ReportRepository _reportRepository;

  const BlockUserUseCase(this._userRepository, this._reportRepository);

  Future<Either<Failure, void>> call(BlockUserParams params) async {
    // Validaciones
    if (params.blockerId == params.blockedUserId) {
      return Left(
        ServerFailure('No puedes bloquearte a ti mismo', originalError: "null"),
      );
    }

    // Bloquear usuario
    final blockResult = await _userRepository.blockUser(
      blockerId: params.blockerId,
      blockedUserId: params.blockedUserId,
    );

    return blockResult.fold(
      (failure) =>
          Left(ServerFailure(failure.toString(), originalError: " null")),
      (_) async {
        // Si se proporciona motivo, crear un reporte automático
        if (params.reason != null) {
          final report = ReportEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            reporterId: params.blockerId,
            reportedUserId: params.blockedUserId,
            type: ReportType.user,
            reason: params.reason!,
            description: params.description ?? 'Usuario bloqueado',
            createdAt: DateTime.now(),
            status: ReportStatus.resolved,
          );

          await _reportRepository.createReport(report);
        }

        return const Right(null);
      },
    );
  }
}

class BlockUserParams {
  final String blockerId;
  final String blockedUserId;
  final ReportReason? reason;
  final String? description;

  const BlockUserParams({
    required this.blockerId,
    required this.blockedUserId,
    this.reason,
    this.description,
  });
}
