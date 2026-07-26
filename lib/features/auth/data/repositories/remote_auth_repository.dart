import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Real implementation of AuthRepository, calling the Laravel
/// Sanctum endpoints. Implements the exact same interface as
/// FakeAuthRepository — this is the payoff of Phase 1's design:
/// no page needed to change to make this swap.
class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await _apiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data['data'];
      await _tokenStorage.saveToken(data['token'] as String);
      await _tokenStorage.saveRememberedEmail(email);
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post('/register', data: {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      final data = response.data['data'];
      await _tokenStorage.saveToken(data['token'] as String);
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/logout');
    } on DioException {
      // Even if the network call fails, clear the local token so the
      // user isn't stuck "logged in" on-device with a dead session.
    } finally {
      await _tokenStorage.clearToken();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = await _tokenStorage.getToken();
    if (token == null) return null;

    try {
      final response = await _apiClient.dio.get('/profile');
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException {
      // Token exists but is invalid/expired server-side — clear it
      // rather than leaving the app in a broken half-logged-in state.
      await _tokenStorage.clearToken();
      return null;
    }
  }
}
