// lib/domain/usecases/base/usecase_interface.dart

// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz unificada para todos los casos de uso.
///
/// Define un contrato estándar para todos los casos de uso donde:
/// - Output: es el tipo de retorno exitoso del caso de uso
/// - Input: es el tipo de parámetro que recibe el caso de uso (NoParams si no recibe)
///
/// Todos los casos de uso deben devolver un Either para manejo consistente de errores.
abstract class UseCaseInterface<Output, Input> {
  /// Ejecuta el caso de uso con los parámetros proporcionados.
  ///
  /// Retorna Either<AppFailure, Output> para manejo de errores consistente.
  Future<Either<AppFailure, Output>> execute(Input params);
}

/// Interfaz para casos de uso que retornan Streams.
abstract class StreamUseCaseInterface<Output, Input> {
  /// Ejecuta el caso de uso con los parámetros proporcionados.
  ///
  /// Retorna un Stream de Either<AppFailure, Output> para manejo de errores consistente.
  Stream<Either<AppFailure, Output>> execute(Input params);
}

/// Clase para representar casos de uso que no requieren parámetros.
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoParams;
  }

  @override
  int get hashCode => 0;

  @override
  String toString() => 'NoParams()';
}
