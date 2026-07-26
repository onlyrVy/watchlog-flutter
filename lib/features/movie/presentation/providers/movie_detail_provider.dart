import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/saved_movie_model.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/saved_movie_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../../search/presentation/providers/search_provider.dart';

final savedMovieRepositoryProvider =
    Provider<SavedMovieRepository>((ref) => SavedMovieRepository());
final reviewRepositoryProvider =
    Provider<ReviewRepository>((ref) => ReviewRepository());

enum MovieDetailStatus { loading, loaded, error }

class MovieDetailState {
  const MovieDetailState({
    required this.status,
    this.movie,
    this.savedMovie,
    this.errorMessage,
    this.isSaving = false,
  });

  final MovieDetailStatus status;
  final MovieModel? movie;
  final SavedMovieModel? savedMovie;
  final String? errorMessage;
  final bool isSaving;

  MovieDetailState copyWith({
    MovieDetailStatus? status,
    MovieModel? movie,
    SavedMovieModel? savedMovie,
    String? errorMessage,
    bool? isSaving,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      savedMovie: savedMovie ?? this.savedMovie,
      errorMessage: errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class MovieDetailNotifier extends StateNotifier<MovieDetailState> {
  MovieDetailNotifier(
      this._movieRepo, this._savedMovieRepo, this._reviewRepo, this.tmdbId)
      : super(const MovieDetailState(status: MovieDetailStatus.loading)) {
    load();
  }

  final dynamic
      _movieRepo; // MovieRepository, typed loosely to avoid circular import churn
  final SavedMovieRepository _savedMovieRepo;
  final ReviewRepository _reviewRepo;
  final int tmdbId;

  Future<void> load() async {
    state = const MovieDetailState(status: MovieDetailStatus.loading);
    try {
      final movie = await _movieRepo.findById(tmdbId);
      final savedList = await _savedMovieRepo.list();
      SavedMovieModel? existing;
      for (final s in savedList) {
        if (s.tmdbId == tmdbId) {
          existing = s;
          break;
        }
      }
      state = MovieDetailState(
          status: MovieDetailStatus.loaded, movie: movie, savedMovie: existing);
    } catch (e) {
      state = MovieDetailState(
          status: MovieDetailStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> saveWithStatus(MovieStatus status) async {
    state = state.copyWith(isSaving: true);
    try {
      if (state.savedMovie == null) {
        final saved =
            await _savedMovieRepo.save(tmdbId: tmdbId, status: status);
        state = state.copyWith(savedMovie: saved, isSaving: false);
      } else {
        final updated = await _savedMovieRepo.updateStatus(
            savedMovieId: state.savedMovie!.id, status: status);
        state = state.copyWith(savedMovie: updated, isSaving: false);
      }
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  Future<void> removeFromLibrary() async {
    if (state.savedMovie == null) return;
    state = state.copyWith(isSaving: true);
    try {
      await _savedMovieRepo.remove(state.savedMovie!.id);
      state = MovieDetailState(
          status: MovieDetailStatus.loaded,
          movie: state.movie,
          savedMovie: null);
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  Future<bool> submitReview({required int rating, String? reviewText}) async {
    if (state.savedMovie == null) return false;
    state = state.copyWith(isSaving: true);
    try {
      ReviewModel review;
      final existingReview = state.savedMovie!.review;
      if (existingReview == null) {
        review = await _reviewRepo.create(
            savedMovieId: state.savedMovie!.id,
            rating: rating,
            reviewText: reviewText);
      } else {
        review = await _reviewRepo.update(
            reviewId: existingReview.id,
            rating: rating,
            reviewText: reviewText);
      }
      final updatedSaved = SavedMovieModel(
        id: state.savedMovie!.id,
        tmdbId: state.savedMovie!.tmdbId,
        status: state.savedMovie!.status,
        review: review,
      );
      state = state.copyWith(savedMovie: updatedSaved, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }
}

final movieDetailProvider =
    StateNotifierProvider.family<MovieDetailNotifier, MovieDetailState, int>(
        (ref, tmdbId) {
  return MovieDetailNotifier(
    ref.watch(movieRepositoryProvider),
    ref.watch(savedMovieRepositoryProvider),
    ref.watch(reviewRepositoryProvider),
    tmdbId,
  );
});
