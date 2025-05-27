// ignore_for_file: always_specify_types

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/auth/auth_state.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

// Mock manual de AuthRepository - solo para pruebas
// Mock predefinido para facilitar testing
class MockAuthRepository extends Mock implements AuthRepository {
  // Proporcionar un stream real para evitar problemas con null
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();
  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) {
    return super.noSuchMethod(
      Invocation.method(#signInWithEmailAndPassword, [email, password]),
      returnValue: Future.value(
        UserEntity(id: 'user123', name: 'Test User'),
      ),
    ) as Future<UserEntity>;
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) {
    return super.noSuchMethod(
      Invocation.method(#signUpWithEmailAndPassword, [
        email,
        password,
        name,
      ]),
      returnValue: Future.value(UserEntity(id: 'user123', name: name)),
    ) as Future<UserEntity>;
  }

  @override
  Future<void> signOut() {
    return super.noSuchMethod(
      Invocation.method(#signOut, []),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }

  @override
  String? getCurrentUserId() {
    return super.noSuchMethod(
      Invocation.method(#getCurrentUserId, []),
      returnValue: 'user123',
    ) as String?;
  }

  // Este método ahora está implementado vía when() en el constructor

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() {
    return super.noSuchMethod(
      Invocation.method(#getCurrentUserData, []),
      returnValue: Future.value({
        'id': 'user123',
        'email': 'test@example.com',
        'displayName': 'Test User',
      }),
    ) as Future<Map<String, dynamic>?>;
  }

  // Stream real para evitar problemas de null
  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  // Constructor mínimo con inicialización del stream
  MockAuthRepository() {
    // Emit true para simular que el usuario está autenticado
    _authStateController.add(true);
  }

  // Implementación directa para métodos críticos
  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<UserEntity?> getCurrentUser() async => UserEntity(
        id: 'user123',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

  @override
  Future<UserEntity?> getUserById(String userId) {
    return super.noSuchMethod(
      Invocation.method(#getUserById, [userId]),
      returnValue: Future.value(UserEntity(id: userId, name: 'Test User')),
    ) as Future<UserEntity?>;
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() {
    return super.noSuchMethod(
      Invocation.method(#signInWithGoogle, []),
      returnValue: Future.value({
        'user': UserEntity(id: 'google123', name: 'Google User'),
        'isNewUser': false,
      }),
    ) as Future<Map<String, dynamic>>;
  }

  @override
  Future<void> deleteAccount() {
    return super.noSuchMethod(
      Invocation.method(#deleteAccount, []),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }

  @override
  Future<void> updateUser(UserEntity user) {
    return super.noSuchMethod(
      Invocation.method(#updateUser, [user]),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) {
    return super.noSuchMethod(
      Invocation.method(#updateUserData, [userId, data]),
      returnValue: Future<void>.value(),
    ) as Future<void>;
  }
}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;
  late SharedPreferences mockPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
    mockAuthRepository = MockAuthRepository();

    // Ahora podemos pasar directamente mockAuthRepository sin casting
    authCubit = AuthCubit(mockAuthRepository, mockPrefs);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is correct', () {
      expect(authCubit.state, isA<AuthState>());
    });

    // Implementar métodos adicionales en AuthCubit para testing
    group('signIn con email y password (solo para testing)', () {
      test('emits loading y success cuando signIn es exitoso', () async {
        // Implementar método signIn en AuthCubit de forma temporal para el test
        when(
          mockAuthRepository.signInWithEmailAndPassword(
            'test@example.com',
            'password123',
          ),
        ).thenAnswer(
          (_) async => UserEntity(
            id: 'user123',
            name: 'Test User',
            photoUrl: 'https://example.com/photo.jpg',
          ),
        );

        when(mockAuthRepository.getCurrentUserData()).thenAnswer(
          (_) async => {
            'id': 'user123',
            'email': 'test@example.com',
            'displayName': 'Test User',
            'hasCompletedOnboarding': true,
          },
        );

        // Llamar explícitamente al método de inicio de sesión
        // Esto es necesario en Clean Architecture para separar claramente
        // la inicialización del mock de la acción bajo prueba
        await authCubit.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        // Verifica el estado final después de la acción
        expect(authCubit.state.status, equals(AuthStatus.authenticated));
        expect(authCubit.state.user?['id'], equals('user123'));
      });

      test('emits loading y error cuando signIn falla', () async {
        when(
          mockAuthRepository.signInWithEmailAndPassword(
            'test@example.com',
            'wrongpassword',
          ),
        ).thenThrow(Exception('Invalid credentials'));

        // Verifica el estado final
        expect(authCubit.state.status, equals(AuthStatus.error));
        expect(authCubit.state.errorMessage, contains('Invalid credentials'));
      });
    });

    group('signOut', () {
      test('emits unauthenticated cuando signOut es exitoso', () async {
        when(mockAuthRepository.signOut()).thenAnswer((_) => Future.value());
        when(mockAuthRepository.getCurrentUserId()).thenReturn('user123');

        await authCubit.logout();

        expect(authCubit.state.status, equals(AuthStatus.unauthenticated));
      });

      test('emits error cuando signOut falla', () async {
        when(
          mockAuthRepository.signOut(),
        ).thenThrow(Exception('Error de cierre de sesión'));
        when(mockAuthRepository.getCurrentUserId()).thenReturn('user123');

        await authCubit.logout();

        expect(authCubit.state.status, equals(AuthStatus.error));
      });
    });
  });
}
