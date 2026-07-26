import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../movie/data/models/movie_model.dart';
import '../../../movie/data/repositories/movie_repository.dart';

final movieRepositoryProvider =
    Provider<MovieRepository>((ref) => MovieRepository());

enum SearchStatus { idle, loading, success, error, empty }

class SearchState {
  const SearchState(
      {required this.status, this.movies = const [], this.errorMessage});

  final SearchStatus status;
  final List<MovieModel> movies;
  final String? errorMessage;
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this._repository)
      : super(const SearchState(status: SearchStatus.idle));

  final MovieRepository _repository;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState(status: SearchStatus.idle);
      return;
    }

    state = const SearchState(status: SearchStatus.loading);

    try {
      final result = await _repository.search(query.trim());
      state = SearchState(
        status:
            result.movies.isEmpty ? SearchStatus.empty : SearchStatus.success,
        movies: result.movies,
      );
    } catch (e) {
      state =
          SearchState(status: SearchStatus.error, errorMessage: e.toString());
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.watch(movieRepositoryProvider));
});
