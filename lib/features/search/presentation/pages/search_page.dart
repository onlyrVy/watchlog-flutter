import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    // Debounce: wait 500ms after the user stops typing before firing
    // the request — avoids hammering the API on every keystroke.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceLg),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search for a movie…',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textSecondary),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchProvider.notifier).search('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    switch (state.status) {
      case SearchStatus.idle:
        return _MessageState(
          icon: Icons.local_movies_outlined,
          message: 'Search for a movie to get started.',
        );
      case SearchStatus.loading:
        return const LoadingIndicator();
      case SearchStatus.error:
        return _MessageState(
          icon: Icons.wifi_off,
          message:
              state.errorMessage ?? 'Something went wrong. Please try again.',
        );
      case SearchStatus.empty:
        return _MessageState(
          icon: Icons.search_off,
          message: 'No movies found. Try a different title.',
        );
      case SearchStatus.success:
        return GridView.builder(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppConstants.spaceMd,
            crossAxisSpacing: AppConstants.spaceMd,
            childAspectRatio: 0.6,
          ),
          itemCount: state.movies.length,
          itemBuilder: (context, index) {
            final movie = state.movies[index];
            return GestureDetector(
              onTap: () => context
                  .push(RouteNames.movieDetailPath(movie.tmdbId.toString())),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                      child: movie.posterPath != null
                          ? Image.network(
                              movie.posterPath!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColors.surface,
                                child: const Icon(Icons.movie_outlined,
                                    color: AppColors.textDisabled),
                              ),
                            )
                          : Container(
                              color: AppColors.surface,
                              child: const Icon(Icons.movie_outlined,
                                  color: AppColors.textDisabled),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie.title,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (movie.year != null)
                    Text(movie.year!, style: AppTextStyles.bodySmall),
                ],
              ),
            );
          },
        );
    }
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.textDisabled),
            const SizedBox(height: AppConstants.spaceMd),
            Text(message,
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
