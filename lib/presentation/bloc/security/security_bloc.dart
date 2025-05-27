// lib/presentation/bloc/security/security_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/usecases/security/create_report_usecase.dart';
import '../../../domain/usecases/security/block_user_usecase.dart';
import '../../../domain/usecases/security/get_pending_reports_usecase.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final CreateReportUseCase _createReportUseCase;
  final dynamic _blockUserUseCase; // Cambiar a dynamic para aceptar mock
  final GetPendingReportsUseCase _getPendingReportsUseCase;
  final GetReportsByUserUseCase _getReportsByUserUseCase;
  final UpdateReportStatusUseCase _updateReportStatusUseCase;
  final FirebaseAuth _auth;

  SecurityBloc({
    required CreateReportUseCase createReportUseCase,
    required dynamic blockUserUseCase, // Cambiar a dynamic
    required GetPendingReportsUseCase getPendingReportsUseCase,
    required GetReportsByUserUseCase getReportsByUserUseCase,
    required UpdateReportStatusUseCase updateReportStatusUseCase,
    FirebaseAuth? auth,
  })  : _createReportUseCase = createReportUseCase,
        _blockUserUseCase = blockUserUseCase,
        _getPendingReportsUseCase = getPendingReportsUseCase,
        _getReportsByUserUseCase = getReportsByUserUseCase,
        _updateReportStatusUseCase = updateReportStatusUseCase,
        _auth = auth ?? FirebaseAuth.instance,
        super(const SecurityState.initial()) {
    on<CreateReportEvent>(_onCreateReport);
    on<BlockUserEvent>(_onBlockUser);
    on<LoadPendingReportsEvent>(_onLoadPendingReports);
    on<LoadReportsByUserEvent>(_onLoadReportsByUser);
    on<UpdateReportStatusEvent>(_onUpdateReportStatus);
  }

  Future<void> _onCreateReport(
    CreateReportEvent event,
    Emitter<SecurityState> emit,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      emit(const SecurityState.error('Usuario no autenticado'));
      return;
    }

    emit(const SecurityState.loading());

    final params = CreateReportParams(
      reporterId: currentUser.uid,
      reportedUserId: event.reportedUserId,
      reportedPlanId: event.reportedPlanId,
      type: event.type,
      reason: event.reason,
      description: event.description,
      evidence: event.evidence,
    );

    final result = await _createReportUseCase(params);

    result.fold(
      (failure) => emit(SecurityState.error(failure.message)),
      (report) => emit(SecurityState.reportCreated(report)),
    );
  }

  Future<void> _onBlockUser(
    BlockUserEvent event,
    Emitter<SecurityState> emit,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      emit(const SecurityState.error('Usuario no autenticado'));
      return;
    }

    emit(const SecurityState.loading());

    final params = BlockUserParams(
      blockerId: currentUser.uid,
      blockedUserId: event.blockedUserId,
      reason: event.reason,
      description: event.description,
    );

    final result = await _blockUserUseCase(params);

    result.fold(
      (failure) => emit(SecurityState.error(failure.message)),
      (_) => emit(const SecurityState.userBlocked()),
    );
  }

  Future<void> _onLoadPendingReports(
    LoadPendingReportsEvent event,
    Emitter<SecurityState> emit,
  ) async {
    emit(const SecurityState.loading());

    final result = await _getPendingReportsUseCase();

    result.fold(
      (failure) => emit(SecurityState.error(failure.message)),
      (reports) => emit(SecurityState.pendingReportsLoaded(reports)),
    );
  }

  Future<void> _onLoadReportsByUser(
    LoadReportsByUserEvent event,
    Emitter<SecurityState> emit,
  ) async {
    emit(const SecurityState.loading());

    final result = await _getReportsByUserUseCase(event.userId);

    result.fold(
      (failure) => emit(SecurityState.error(failure.message)),
      (reports) => emit(SecurityState.userReportsLoaded(reports)),
    );
  }

  Future<void> _onUpdateReportStatus(
    UpdateReportStatusEvent event,
    Emitter<SecurityState> emit,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      emit(const SecurityState.error('Usuario no autenticado'));
      return;
    }

    emit(const SecurityState.loading());

    final params = UpdateReportStatusParams(
      reportId: event.reportId,
      status: event.status,
      moderatorId: currentUser.uid,
      moderatorNotes: event.moderatorNotes,
    );

    final result = await _updateReportStatusUseCase(params);

    result.fold(
      (failure) => emit(SecurityState.error(failure.message)),
      (report) => emit(SecurityState.reportStatusUpdated(report)),
    );
  }
}
