import '../../domain/entities/movie.dart';

class MovieDetailDto {
  final int id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;

  MovieDetailDto({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieDetailDto.fromJson(Map<String, dynamic> j) => MovieDetailDto(
    id: j['id'] as int,
    title: j['title'] as String?,
    overview: j['overview'] as String?,
    posterPath: j['poster_path'] as String?,
    backdropPath: j['backdrop_path'] as String?,
    voteAverage: (j['vote_average'] is num) ? (j['vote_average'] as num).toDouble() : null,
    releaseDate: j['release_date'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'release_date': releaseDate,
  };

  Movie toEntity() => Movie(
    id: id,
    title: title ?? '',
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
  );

  factory MovieDetailDto.fromEntity(Movie e) => MovieDetailDto(
    id: e.id,
    title: e.title,
    overview: e.overview,
    posterPath: e.posterPath,
    backdropPath: e.backdropPath,
    voteAverage: e.voteAverage,
    releaseDate: e.releaseDate,
  );
}
