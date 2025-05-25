// lib/domain/usecases/base/usecase.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz base para todos los casos de uso
///
/// Define un contrato estándar para todos los casos de uso donde:
/// - Type: es el tipo de retorno exitoso del caso de uso
/// - Params: es el tipo de parámetro que recibe el caso de uso
///
/// Todos los casos de uso deben devolver un Either para manejo consistente de errores.
abstract class UseCase<Type, Params> {
  Future<Either<AppFailure, Type>> call(Params params);
}

/// Caso de uso que no requiere parámetros
abstract class NoParamsUseCase<Type> {
  Future<Either<AppFailure, Type>> call();
}

/// Caso de uso que no requiere parámetros y retorna un Stream
abstract class StreamNoParamsUseCase<Type> {
  Stream<Either<AppFailure, Type>> call();
}

/// Caso de uso que requiere parámetros y retorna un Stream
abstract class StreamUseCase<Type, Params> {
  Stream<Either<AppFailure, Type>> call(Params params);
}

/// Representa un caso de uso sin parámetros
class NoParams {
  const NoParams();
}
