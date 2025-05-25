// libcore/blocs/auth/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial, // Estado inicial
  loading,
  authenticated,
  unauthenticated,
  error,
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    Map<String, dynamic>? user,
    @Default(false) bool hasUserProfile,
    String? errorMessage,
  }) = _AuthState;
}
