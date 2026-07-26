import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';

class MovieSearchResult {
  const MovieSearchResult(
      {required this.movies, required this.page, required this.totalPages});
  final List<MovieModel> movies;
  final int page;
  final int totalPages;
}

class MovieRepository {
  MovieRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<MovieSearchResult> search(String query, {int page = 1}) async {
    try {
      final response =
          await _apiClient.dio.get('/movies/search', queryParameters: {
        'query': query,
        'page': page,
      });

      final data = response.data['data'];
      final results = (data['results'] as List<dynamic>)
          .map((m) => MovieModel.fromJson(m as Map<String, dynamic>))
          .toList();

      return MovieSearchResult(
        movies: results,
        page: data['page'] as int,
        totalPages: data['total_pages'] as int,
      );
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }

  Future<MovieModel> findById(int tmdbId) async {
    try {
      final response = await _apiClient.dio.get('/movies/$tmdbId');
      return MovieModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiClient.mapError(e);
    }
  }
}
