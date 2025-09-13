import '../../domain/entities/tv_show.dart';

class TvDto {
  final int id;
  final String? name;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? firstAirDate;

  TvDto({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
  });

  factory TvDto.fromJson(Map<String, dynamic> j) => TvDto(
    id: j['id'] as int,
    name: j['name'] as String?,
    posterPath: j['poster_path'] as String?,
    backdropPath: j['backdrop_path'] as String?,
    voteAverage: (j['vote_average'] is num) ? (j['vote_average'] as num).toDouble() : null,
    firstAirDate: j['first_air_date'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'first_air_date': firstAirDate,
  };

  TvShow toEntity() => TvShow(
    id: id,
    name: name ?? '',
    posterPath: posterPath,
    backdropPath: backdropPath,
    voteAverage: voteAverage,
    firstAirDate: firstAirDate,
  );

  factory TvDto.fromEntity(TvShow e) => TvDto(
    id: e.id,
    name: e.name,
    posterPath: e.posterPath,
    backdropPath: e.backdropPath,
    voteAverage: e.voteAverage,
    firstAirDate: e.firstAirDate,
  );
}
