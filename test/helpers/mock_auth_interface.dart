// helpers/mock_auth_interface.dart
// ignore_for_file: always_specify_types

import 'package:mockito/mockito.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/interfaces/auth_repository_interface.dart';

class MockAuthRepository extends Mock implements AuthRepositoryInterface {
  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(
            UserEntity(
              id: 'user123',
              name: 'Test User',
              photoUrl: 'https://example.com/photo.jpg',
            ),
          ),
        )
        as Future<UserEntity>;
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    return super.noSuchMethod(
          Invocation.method(#signUpWithEmailAndPassword, [
            email,
            password,
            name,
          ]),
          returnValue: Future.value(
            UserEntity(
              id: 'user123',
              name: name,
              photoUrl: 'https://example.com/photo.jpg',
            ),
          ),
        )
        as Future<UserEntity>;
  }

  @override
  Future<void> signOut() async {
    return super.noSuchMethod(
          Invocation.method(#signOut, []),
          returnValue: Future<void>.value(),
        )
        as Future<void>;
  }
}
