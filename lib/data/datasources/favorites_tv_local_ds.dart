import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/tv_detail.dart';

class FavoritesTvLocalDataSource {
  static const _box = 'favorites_tv_box';

  Future<Box> _open() async => Hive.isBoxOpen(_box) ? Hive.box(_box) : await Hive.openBox(_box);

  Future<void> put(TvDetail tv) async {
    final b = await _open();
    await b.put(tv.id, {
      'id': tv.id,
      'name': tv.name,
      'poster_path': tv.posterPath,
      'backdrop_path': tv.backdropPath,
      'vote_average': tv.voteAverage,
      'first_air_date': tv.firstAirDate,
      'genres': tv.genres,
    });
  }

  Future<void> delete(int id) async {
    final b = await _open();
    await b.delete(id);
  }

  Future<bool> exists(int id) async {
    final b = await _open();
    return b.containsKey(id);
  }

  Future<List<TvDetail>> getAll() async {
    final b = await _open();
    return b.values.map((raw) {
      final m = Map<String, dynamic>.from(raw as Map);
      return TvDetail(
        id: m['id'] as int,
        name: (m['name'] as String?) ?? '',
        overview: null,
        posterPath: m['poster_path'] as String?,
        backdropPath: m['backdrop_path'] as String?,
        voteAverage: (m['vote_average'] as num?)?.toDouble(),
        firstAirDate: m['first_air_date'] as String?,
        genreIds: const [],
        genres: (m['genres'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
    }).toList();
  }

  Stream<List<TvDetail>> watchAll() async* {
    final b = await _open();
    yield await getAll();
    yield* b.watch().asyncMap((_) => getAll());
  }
}
