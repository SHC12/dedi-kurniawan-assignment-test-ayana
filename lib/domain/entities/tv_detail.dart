import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? firstAirDate;
  final List<int> genreIds;
  final List<String> genres;

  const TvDetail({
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

  @override
  List<Object?> get props => [id, name, posterPath, voteAverage, firstAirDate, genres];
}
