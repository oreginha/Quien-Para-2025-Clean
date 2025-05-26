import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

void main() {
  group('FailureHelper', () {
    test('should convert network error to NetworkFailure', () {
      // Arrange
      final error = Exception('SocketException: Failed to connect');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, contains('Error de red'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert not found error to NotFoundFailure', () {
      // Arrange
      final error = Exception('404: Resource not found');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, contains('Recurso no encontrado'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert database error to DatabaseFailure', () {
      // Arrange
      final error = Exception('Firestore: Document does not exist');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<DatabaseFailure>());
      expect(failure.message, contains('Error de base de datos'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert validation error to ValidationFailure', () {
      // Arrange
      final error = Exception('Invalid input: Email is not valid');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, contains('Error de validación'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert auth error to AuthFailure', () {
      // Arrange
      final error = Exception('Unauthorized: Invalid credentials');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<AuthFailure>());
      expect(failure.message, contains('Error de autenticación'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert permission error to PermissionFailure', () {
      // Arrange
      final error = Exception('Permission denied: Insufficient privileges');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<PermissionFailure>());
      expect(failure.message, contains('Error de permisos'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert cache error to CacheFailure', () {
      // Arrange
      final error = Exception('Cache: Failed to read data');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<CacheFailure>());
      expect(failure.message, contains('Error de caché'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test('should convert unknown error to UnexpectedFailure', () {
      // Arrange
      final error = Exception('Some unexpected error');
      final stackTrace = StackTrace.current;

      // Act
      final failure = FailureHelper.fromException(error, stackTrace);

      // Assert
      expect(failure, isA<UnexpectedFailure>());
      expect(failure.message, contains('Error inesperado'));
      expect(failure.stackTrace, equals(stackTrace));
      expect(failure.originalError, equals(error));
    });

    test(
      'should return original failure if input is already an AppFailure',
      () {
        // Arrange
        final originalFailure = NetworkFailure(
          message: 'Original network error',
          code: 'NETWORK_ERROR',
          stackTrace: StackTrace.current,
          originalError: Exception('Original error'),
        );

        // Act
        final failure = FailureHelper.fromException(originalFailure);

        // Assert
        expect(failure, equals(originalFailure));
      },
    );
  });
}
