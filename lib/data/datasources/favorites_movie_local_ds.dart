import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/movie.dart';

class FavoritesMovieLocalDataSource {
  static const _boxName = 'favorites_box';

  Future<Box> _box() async => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);

  Future<void> put(Movie m) async {
    final box = await _box();
    await box.put(m.id, _toMap(m));
  }

  Future<void> delete(int id) async {
    final box = await _box();
    await box.delete(id);
  }

  Future<bool> exists(int id) async {
    final box = await _box();
    return box.containsKey(id);
  }

  Future<List<Movie>> getAll() async {
    final box = await _box();
    return box.values.map((e) => _fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Stream<List<Movie>> watchAll() async* {
    final box = await _box();
    yield await getAll();
    yield* box.watch().asyncMap((_) => getAll());
  }

  Map<String, dynamic> _toMap(Movie m) => {
    'id': m.id,
    'title': m.title,
    'poster_path': m.posterPath,
    'backdrop_path': m.backdropPath,
    'vote_average': m.voteAverage,
    'release_date': m.releaseDate,
  };

  Movie _fromMap(Map<String, dynamic> j) => Movie(
    id: j['id'] as int,
    title: (j['title'] as String?) ?? '',
    posterPath: j['poster_path'] as String?,
    backdropPath: j['backdrop_path'] as String?,
    voteAverage: (j['vote_average'] as num?)?.toDouble(),
    releaseDate: j['release_date'] as String?,
  );
}
