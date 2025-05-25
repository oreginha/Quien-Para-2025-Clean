// ignore_for_file: unused_field, override_on_non_overriding_member, always_specify_types, subtype_of_sealed_class

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => MockUser();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return Future.value(MockUserCredential());
  }

  @override
  Future<void> signOut() async {}

  @override
  Stream<User?> authStateChanges() {
    return Stream.value(MockUser());
  }
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test_user_id';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';

  @override
  bool get isAnonymous => false;
}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User get user => MockUser();
}
