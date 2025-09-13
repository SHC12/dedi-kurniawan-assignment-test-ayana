import '../../domain/entities/movie.dart';

class MovieDto {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;

  MovieDto({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.releaseDate,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) => MovieDto(
    id: json['id'] ?? 0,
    title: json['title'] ?? json['name'] ?? '',
    overview: json['overview'],
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
    voteAverage: (json['vote_average'] is num) ? (json['vote_average'] as num).toDouble() : null,
    releaseDate: json['release_date'] ?? json['first_air_date'],
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
    id: id, title: title, overview: overview, posterPath: posterPath,
    backdropPath: backdropPath, voteAverage: voteAverage, releaseDate: releaseDate,
  );

  static List<MovieDto> listFromJson(List<dynamic> l) => l.map((e) => MovieDto.fromJson(e)).toList();
}
