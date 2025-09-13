import '../../domain/entities/tv_detail.dart';

class TvDetailDto {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? firstAirDate;
  final List<int> genreIds;
  final List<String> genres;

  TvDetailDto({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.genreIds,
    required this.genres,
  });

  factory TvDetailDto.fromJson(Map<String, dynamic> j) {
    final gens = const <String>[];
    final genIds = const <int>[];

    return TvDetailDto(
      id: j['id'] as int,
      name: j['name'] as String?,
      overview: j['overview'] as String?,
      posterPath: j['poster_path'] as String?,
      backdropPath: j['backdrop_path'] as String?,
      voteAverage: (j['vote_average'] is num) ? (j['vote_average'] as num).toDouble() : null,
      firstAirDate: j['first_air_date'] as String?,
      genreIds: genIds,
      genres: gens,
    );
  }

  TvDetail toEntity() => TvDetail(
    id: id,
    name: name ?? '',
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    voteAverage: voteAverage,
    firstAirDate: firstAirDate,
    genreIds: genreIds,
    genres: genres,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'first_air_date': firstAirDate,
    'genre_ids': genreIds,
    'genres': genres,
  };

  factory TvDetailDto.fromEntity(TvDetail e) => TvDetailDto(
    id: e.id,
    name: e.name,
    overview: e.overview,
    posterPath: e.posterPath,
    backdropPath: e.backdropPath,
    voteAverage: e.voteAverage,
    firstAirDate: e.firstAirDate,
    genreIds: e.genreIds,
    genres: e.genres,
  );
}
