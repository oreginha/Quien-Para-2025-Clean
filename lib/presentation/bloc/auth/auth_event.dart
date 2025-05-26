// lib/core/models/auth_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const AuthEvent._(); // Add this line

  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;
  const factory AuthEvent.signInWithGoogle() = SignInWithGoogle;
  const factory AuthEvent.signOut() = SignOut;
  const factory AuthEvent.deleteAccount() = DeleteAccount;
  const factory AuthEvent.completeOnboarding() = CompleteOnboarding;
}
