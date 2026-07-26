import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../movie/data/models/saved_movie_model.dart';
import '../../../movie/presentation/providers/movie_detail_provider.dart';

enum LibraryStatus { loading, loaded, error }

class LibraryState {
  const LibraryState(
      {required this.status, this.movies = const [], this.errorMessage});

  final LibraryStatus status;
  final List<SavedMovieModel> movies;
  final String? errorMessage;

  List<SavedMovieModel> forStatus(MovieStatus filter) =>
      movies.where((m) => m.status == filter).toList();
}

class LibraryNotifier extends StateNotifier<LibraryState> {
  LibraryNotifier(this._ref)
      : super(const LibraryState(status: LibraryStatus.loading)) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const LibraryState(status: LibraryStatus.loading);
    try {
      final repository = _ref.read(savedMovieRepositoryProvider);
      final movies = await repository.list();
      state = LibraryState(status: LibraryStatus.loaded, movies: movies);
    } catch (e) {
      state =
          LibraryState(status: LibraryStatus.error, errorMessage: e.toString());
    }
  }
}

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, LibraryState>((ref) {
  return LibraryNotifier(ref);
});
