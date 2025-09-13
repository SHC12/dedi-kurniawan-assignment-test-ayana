import 'media_kind.dart';

class DetailVM {
  final int id;
  final MediaKind kind;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? vote;
  final String? year;
  final List<String> genres;
  const DetailVM({
    required this.id,
    required this.kind,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.vote,
    required this.year,
    required this.genres,
  });
}
