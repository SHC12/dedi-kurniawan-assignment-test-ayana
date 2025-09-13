import '../../../../core/tmdb_genres.dart';
import '../../../../domain/entities/media.dart';

String? _yearOf(Media m) {
  final s = m.mediaType == 'movie' ? m.releaseDate : m.firstAirDate;
  if (s == null || s.isEmpty) return null;
  return s.substring(0, 4);
}

List<String> genresOf(Media m) => m.genreIds.map((id) => genreNameFromId(id, m.mediaType)).toList();

String? countryNameToCode(String name) {
  switch (name) {
    case 'United States':
      return 'US';

    case 'Indonesia':
      return 'ID';
    default:
      return null;
  }
}

bool _matchesCategory(Media m, String category) {
  if (category == 'All') return true;
  if (category == 'Movies') return m.mediaType == 'movie';
  if (category == 'Series' || category == 'TV') return m.mediaType == 'tv';
  if (category == 'Anime') {
    final gs = genresOf(m);
    return gs.any((g) => g.contains('Animation')) || m.originalLanguage == 'ja' || m.originCountry.contains('JP');
  }
  return true;
}

List<Media> applyExploreFilters(
  List<Media> src, {
  required String category,
  required Set<String> genres,
  required int? year,
  required String country,
  required String sortBy,
}) {
  final code = countryNameToCode(country);
  var list = src.where((m) {
    if (!_matchesCategory(m, category)) return false;
    if (genres.isNotEmpty) {
      final names = genresOf(m);
      if (!genres.every((g) => names.any((n) => n.toLowerCase() == g.toLowerCase()))) return false;
    }
    if (year != null) {
      final y = _yearOf(m);
      if (y == null || y != year.toString()) return false;
    }
    if (code != null && code.isNotEmpty) {
      if (!m.originCountry.contains(code)) return false;
    }
    return true;
  }).toList();

  switch (sortBy) {
    case 'Latest':
      list.sort((a, b) => ((_yearOf(b) ?? '0')).compareTo((_yearOf(a) ?? '0')));
      break;
    case 'Top Rated':
      list.sort((a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0));
      break;
    default:
      break;
  }
  return list;
}
