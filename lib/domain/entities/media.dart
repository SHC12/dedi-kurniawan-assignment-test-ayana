import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final int id;
  final String mediaType;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;
  final String? firstAirDate;
  final List<int> genreIds;
  final List<String> originCountry;
  final String? originalLanguage;

  const Media({
    required this.id,
    required this.mediaType,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.firstAirDate,
    required this.genreIds,
    required this.originCountry,
    required this.originalLanguage,
  });

  @override
  List<Object?> get props => [id, mediaType, title, posterPath, voteAverage];
}
