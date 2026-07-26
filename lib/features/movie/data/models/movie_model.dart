/// Represents a movie as returned by our Laravel /movies endpoints
/// (which proxy and reshape TMDb's data). Two shapes exist upstream —
/// search results vs. full detail — but we model them as one class
/// with nullable detail-only fields, since Flutter UI can just check
/// for null rather than juggling two separate model types.
class MovieModel {
  const MovieModel({
    required this.tmdbId,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.year,
    this.overview = '',
    this.rating = 0,
    this.genres = const [],
    this.runtime,
  });

  final int tmdbId;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? year;
  final String overview;
  final double rating;
  final List<String> genres;
  final int? runtime;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      tmdbId: json['tmdb_id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      year: json['year'] as String?,
      overview: json['overview'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => g.toString())
              .toList() ??
          const [],
      runtime: json['runtime'] as int?,
    );
  }
}
