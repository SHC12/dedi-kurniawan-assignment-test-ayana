import '../../domain/entities/media.dart';

class MediaDto {
  final int id;
  final String mediaType;
  final String? title;
  final String? name;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;
  final String? firstAirDate;
  final List<int> genreIds;
  final List<String> originCountry;
  final String? originalLanguage;

  MediaDto({
    required this.id,
    required this.mediaType,
    required this.title,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.firstAirDate,
    required this.genreIds,
    required this.originCountry,
    required this.originalLanguage,
  });

  factory MediaDto.fromJson(Map<String, dynamic> j) {
    return MediaDto(
      id: j['id'] as int,
      mediaType: (j['media_type'] ?? '').toString(),
      title: j['title'] as String?,
      name: j['name'] as String?,
      posterPath: j['poster_path'] as String?,
      backdropPath: j['backdrop_path'] as String?,
      voteAverage: (j['vote_average'] is num) ? (j['vote_average'] as num).toDouble() : null,
      releaseDate: j['release_date'] as String?,
      firstAirDate: j['first_air_date'] as String?,
      genreIds: (j['genre_ids'] as List?)?.whereType<int>().toList() ?? const [],
      originCountry: (j['origin_country'] as List?)?.whereType<String>().toList() ?? const [],
      originalLanguage: j['original_language'] as String?,
    );
  }

  Media toEntity() {
    return Media(
      id: id,
      mediaType: mediaType,
      title: (title?.isNotEmpty ?? false) ? title! : (name ?? ''),
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'media_type': mediaType,
    'title': title,
    'name': name,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'release_date': releaseDate,
    'first_air_date': firstAirDate,
    'genre_ids': genreIds,
    'origin_country': originCountry,
    'original_language': originalLanguage,
  };

  factory MediaDto.fromEntity(Media m) => MediaDto(
    id: m.id,
    mediaType: m.mediaType,
    title: m.mediaType == 'movie' ? m.title : null,
    name: m.mediaType == 'tv' ? m.title : null,
    posterPath: m.posterPath,
    backdropPath: m.backdropPath,
    voteAverage: m.voteAverage,
    releaseDate: m.releaseDate,
    firstAirDate: m.firstAirDate,
    genreIds: m.genreIds,
    originCountry: m.originCountry,
    originalLanguage: m.originalLanguage,
  );
}
