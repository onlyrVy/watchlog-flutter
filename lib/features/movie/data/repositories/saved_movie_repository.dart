import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/saved_movie_model.dart';

class SavedMovieRepository {
  SavedMovieRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<SavedMovieModel>> list({String? status, String? sort}) async {
    try {
      final response =
          await _apiClient.dio.get('/saved-movies', queryParameters: {
        if (status != null) 'status': status,
        if (sort != null) 'sort': sort,
      });

      // ApiResponseService flattens the paginator when wrapping it —
      // the movie list sits directly under "data", not "data.data".
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((m) => SavedMovieModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  Future<SavedMovieModel> save(
      {required int tmdbId, required MovieStatus status}) async {
    try {
      final response = await _apiClient.dio.post('/saved-movies', data: {
        'tmdb_id': tmdbId,
        'status': status.name,
      });
      return SavedMovieModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  Future<SavedMovieModel> updateStatus(
      {required int savedMovieId, required MovieStatus status}) async {
    try {
      final response =
          await _apiClient.dio.put('/saved-movies/$savedMovieId', data: {
        'status': status.name,
      });
      return SavedMovieModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  Future<void> remove(int savedMovieId) async {
    try {
      await _apiClient.dio.delete('/saved-movies/$savedMovieId');
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }
}
