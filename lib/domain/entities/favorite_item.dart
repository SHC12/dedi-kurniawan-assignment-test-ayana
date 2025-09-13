import 'media_kind.dart';

class FavoriteItem {
  final int id;
  final MediaKind kind;
  final String title;
  final String? posterPath;
  final double? vote;
  final String? year;

  const FavoriteItem({
    required this.id,
    required this.kind,
    required this.title,
    this.posterPath,
    this.vote,
    this.year,
  });
}
