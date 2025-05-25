// lib/domain/usecases/base/base_usecase.dart

/// Clase base para casos de uso que no reciben parámetros
abstract class NoParamsUseCase<T> {
  Future<T> call();
}

/// Clase base para casos de uso que reciben un parámetro
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Clase base para casos de uso que reciben dos parámetros
abstract class UseCaseWithTwoParams<T, P1, P2> {
  Future<T> call(P1 param1, P2 param2);
}

/// Clase base para casos de uso que reciben tres parámetros
abstract class UseCaseWithThreeParams<T, P1, P2, P3> {
  Future<T> call(P1 param1, P2 param2, P3 param3);
}

/// Clase para representar casos de uso que no requieren parámetros
class NoParams {
  const NoParams();
}
