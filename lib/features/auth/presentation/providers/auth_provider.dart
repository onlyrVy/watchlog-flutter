import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Swap this single provider to point at `RemoteAuthRepository` in
/// Phase 2 — everything downstream (authProvider, all pages) is
/// unaffected because they only know about the `AuthRepository` interface.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.user, this.errorMessage});

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState.initial() : this(status: AuthStatus.unknown);

  AuthState copyWith({AuthStatus? status, UserModel? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

/// Owns auth state for the whole app. Pages call methods here and
/// react to [AuthState] rather than managing their own booleans —
/// this is also what the router reads to decide redirects.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _restoreSession();
  }

  final AuthRepository _repository;

  Future<void> _restoreSession() async {
    final user = await _repository.getCurrentUser();
    state = AuthState(
      status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      user: user,
    );
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final user = await _repository.login(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: _friendlyError(e));
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _repository.register(
        username: username,
        email: email,
        password: password,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: _friendlyError(e));
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  String _friendlyError(Object e) {
    // Centralized so the mapping from exceptions -> user-facing copy
    // lives in one place, ready to expand with real HTTP status codes
    // (401, 422, timeouts, no-connection) in Phase 2.
    return e.toString().replaceFirst('Exception: ', '');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
