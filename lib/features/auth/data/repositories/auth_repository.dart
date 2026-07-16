import '../models/user_model.dart';

/// Abstraction over "however auth actually happens". The presentation
/// layer (login/register pages, providers) depends only on this
/// interface, never on `http`/`dio` directly.
///
/// In Phase 2 we add `RemoteAuthRepository implements AuthRepository`
/// that calls the Laravel Sanctum endpoints (`POST /register`,
/// `POST /login`, `POST /logout`, `GET /profile`) and swap it in at
/// the provider level — no changes needed to LoginPage/RegisterPage.
abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();

  /// Returns the currently persisted user, if a session exists.
  Future<UserModel?> getCurrentUser();
}

/// Temporary in-memory fake so the UI is fully clickable in Phase 1
/// before the Laravel backend exists. Simulates network latency and
/// basic validation so loading/error states can be built and tested now.
class FakeAuthRepository implements AuthRepository {
  UserModel? _session;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (password.length < 8) {
      throw Exception('Invalid email or password');
    }

    _session = UserModel(
      id: 1,
      username: email.split('@').first,
      email: email,
      joinDate: DateTime.now(),
    );
    return _session!;
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _session = UserModel(
      id: 1,
      username: username,
      email: email,
      joinDate: DateTime.now(),
    );
    return _session!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _session = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _session;
  }
}
