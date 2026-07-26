import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/saved_movie_model.dart';
import '../providers/movie_detail_provider.dart';

class MovieDetailPage extends ConsumerWidget {
  const MovieDetailPage({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tmdbId = int.tryParse(movieId);
    if (tmdbId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Movie')),
        body: Center(
            child: Text('Invalid movie id', style: AppTextStyles.bodyMedium)),
      );
    }

    final state = ref.watch(movieDetailProvider(tmdbId));

    return Scaffold(
      appBar: AppBar(title: Text(state.movie?.title ?? 'Movie Details')),
      body: switch (state.status) {
        MovieDetailStatus.loading => const LoadingIndicator(),
        MovieDetailStatus.error => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceLg),
              child: Text(state.errorMessage ?? 'Something went wrong.',
                  style: AppTextStyles.bodyMedium),
            ),
          ),
        MovieDetailStatus.loaded =>
          _MovieDetailBody(tmdbId: tmdbId, state: state),
      },
    );
  }
}

class _MovieDetailBody extends ConsumerWidget {
  const _MovieDetailBody({required this.tmdbId, required this.state});

  final int tmdbId;
  final MovieDetailState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = state.movie!;
    final notifier = ref.read(movieDetailProvider(tmdbId).notifier);

    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: SizedBox(
                width: 110,
                height: 165,
                child: movie.posterPath != null
                    ? Image.network(movie.posterPath!, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.movie_outlined)),
              ),
            ),
            const SizedBox(width: AppConstants.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (movie.year != null) movie.year!,
                      if (movie.runtime != null) '${movie.runtime} min',
                    ].join(' • '),
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.star),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  if (movie.genres.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: movie.genres
                          .map((g) => Chip(
                                label: Text(g, style: AppTextStyles.bodySmall),
                                backgroundColor: AppColors.surfaceElevated,
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spaceLg),
        Text('Overview', style: AppTextStyles.titleMedium),
        const SizedBox(height: 6),
        Text(movie.overview.isEmpty ? 'No overview available.' : movie.overview,
            style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppConstants.spaceXl),
        Text('Your Status', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppConstants.spaceSm),
        _StatusSelector(
          current: state.savedMovie?.status,
          isSaving: state.isSaving,
          onSelected: (status) => notifier.saveWithStatus(status),
        ),
        if (state.savedMovie != null) ...[
          const SizedBox(height: AppConstants.spaceMd),
          OutlinedButton.icon(
            onPressed:
                state.isSaving ? null : () => _confirmRemove(context, notifier),
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            label: const Text('Remove from Library',
                style: TextStyle(color: AppColors.error)),
          ),
          const SizedBox(height: AppConstants.spaceXl),
          Text('Your Review', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppConstants.spaceSm),
          _ReviewForm(
            savedMovie: state.savedMovie!,
            isSaving: state.isSaving,
            onSubmit: (rating, text) =>
                notifier.submitReview(rating: rating, reviewText: text),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmRemove(
      BuildContext context, MovieDetailNotifier notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from library?'),
        content: const Text(
            'This will also delete any review you\'ve written for this movie.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.removeFromLibrary();
    }
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector(
      {required this.current,
      required this.isSaving,
      required this.onSelected});

  final MovieStatus? current;
  final bool isSaving;
  final void Function(MovieStatus) onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: MovieStatus.values.map((status) {
        final isSelected = current == status;
        return ChoiceChip(
          label: Text(_label(status)),
          selected: isSelected,
          onSelected: isSaving ? null : (_) => onSelected(status),
          selectedColor: AppColors.accent,
          labelStyle: TextStyle(
              color: isSelected ? Colors.black : AppColors.textPrimary),
          backgroundColor: AppColors.surface,
        );
      }).toList(),
    );
  }

  String _label(MovieStatus status) => switch (status) {
        MovieStatus.watchlist => 'Watchlist',
        MovieStatus.watching => 'Watching',
        MovieStatus.watched => 'Watched',
      };
}

class _ReviewForm extends StatefulWidget {
  const _ReviewForm(
      {required this.savedMovie,
      required this.isSaving,
      required this.onSubmit});

  final SavedMovieModel savedMovie;
  final bool isSaving;
  final Future<bool> Function(int rating, String? text) onSubmit;

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  late int _rating = widget.savedMovie.review?.rating ?? 0;
  late final _textController =
      TextEditingController(text: widget.savedMovie.review?.reviewText ?? '');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(10, (i) {
            final starIndex = i + 1;
            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                starIndex <= _rating ? Icons.star : Icons.star_border,
                color: AppColors.star,
                size: 22,
              ),
              onPressed: () => setState(() => _rating = starIndex),
            );
          }),
        ),
        const SizedBox(height: AppConstants.spaceSm),
        TextField(
          controller: _textController,
          maxLines: 4,
          decoration: const InputDecoration(
              hintText: 'Write your thoughts (optional)...'),
        ),
        const SizedBox(height: AppConstants.spaceMd),
        PrimaryButton(
          label: widget.savedMovie.review == null
              ? 'Submit Review'
              : 'Update Review',
          isLoading: widget.isSaving,
          onPressed: _rating == 0
              ? null
              : () => widget.onSubmit(
                  _rating,
                  _textController.text.trim().isEmpty
                      ? null
                      : _textController.text.trim()),
        ),
      ],
    );
  }
}
