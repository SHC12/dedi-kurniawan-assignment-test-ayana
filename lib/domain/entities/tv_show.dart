import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? firstAirDate;

  const TvShow({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.firstAirDate,
  });

  @override
  List<Object?> get props => [id, name, posterPath, voteAverage, firstAirDate];
}
