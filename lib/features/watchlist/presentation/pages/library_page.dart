import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../movie/data/models/movie_model.dart';
import '../../../movie/data/models/saved_movie_model.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../providers/library_provider.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(libraryProvider.notifier).load(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Watchlist'),
            Tab(text: 'Watching'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: switch (state.status) {
        LibraryStatus.loading => const LoadingIndicator(),
        LibraryStatus.error => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceLg),
              child: Text(state.errorMessage ?? 'Something went wrong.',
                  style: AppTextStyles.bodyMedium),
            ),
          ),
        LibraryStatus.loaded => TabBarView(
            controller: _tabController,
            children: [
              _LibraryList(
                  movies: state.forStatus(MovieStatus.watchlist),
                  emptyLabel: 'Watchlist'),
              _LibraryList(
                  movies: state.forStatus(MovieStatus.watching),
                  emptyLabel: 'Watching'),
              _LibraryList(
                  movies: state.forStatus(MovieStatus.watched),
                  emptyLabel: 'Watched'),
            ],
          ),
      },
    );
  }
}

class _LibraryList extends StatelessWidget {
  const _LibraryList({required this.movies, required this.emptyLabel});

  final List<SavedMovieModel> movies;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bookmark_border,
                  size: 40, color: AppColors.textDisabled),
              const SizedBox(height: AppConstants.spaceMd),
              Text('No movies in $emptyLabel yet',
                  style: AppTextStyles.titleMedium),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      itemCount: movies.length,
      itemBuilder: (context, index) => _LibraryCard(savedMovie: movies[index]),
    );
  }
}

/// Fetches its own movie details, since SavedMovieModel only holds a
/// tmdb_id — matches the "don't duplicate movie data" design.
class _LibraryCard extends ConsumerWidget {
  const _LibraryCard({required this.savedMovie});

  final SavedMovieModel savedMovie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<MovieModel>(
      future: ref.read(movieRepositoryProvider).findById(savedMovie.tmdbId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppConstants.spaceMd),
            child: SizedBox(height: 90, child: LoadingIndicator(size: 20)),
          );
        }
        final movie = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
          child: GestureDetector(
            onTap: () => context
                .push(RouteNames.movieDetailPath(savedMovie.tmdbId.toString())),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: SizedBox(
                    width: 70,
                    height: 100,
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
                      Text(movie.title, style: AppTextStyles.titleMedium),
                      if (movie.year != null)
                        Text(movie.year!, style: AppTextStyles.bodySmall),
                      if (savedMovie.review != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: AppColors.star),
                            const SizedBox(width: 4),
                            Text('${savedMovie.review!.rating}/10',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
