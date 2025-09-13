import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/config.dart';
import '../models/movie_dto.dart';

const _kCacheBox = 'cacheBox';
const _kFavoritesBox = 'favoritesBox';
const _kPopularKey = 'popular_cache';
const _kSearchPrefix = 'search_cache_';
const _kTimePrefix = 'cache_time_';

class LocalCacheDataSource {
  Box? _cache;
  late Box _fav;
  final _favStream = StreamController<List<MovieDto>>.broadcast();

  Future<void> init() async {
    _cache ??= await Hive.openBox(_kCacheBox);
    _fav = await Hive.openBox(_kFavoritesBox);
    _emitFav();
  }

  bool _isFresh(String key) {
    final t = _cache?.get('$_kTimePrefix$key') as int?;
    if (t == null) return false;
    final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(t)).inMinutes;
    return age < kCacheTtlMinutes;
  }

  Future<List<MovieDto>> getPopularCached() async {
    final raw = _cache?.get(_kPopularKey) as List?;
    if (raw == null) return [];
    return raw.map((e) => MovieDto.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> savePopular(List<MovieDto> list) async {
    await _cache?.put(_kPopularKey, list.map((e) => e.toJson()).toList());
    await _cache?.put('$_kTimePrefix$_kPopularKey', DateTime.now().millisecondsSinceEpoch);
  }

  bool isPopularFresh() => _isFresh(_kPopularKey);

  String keyForQuery(String q) => '$_kSearchPrefix$q';

  Future<List<MovieDto>> getSearchCached(String q) async {
    final key = keyForQuery(q);
    final raw = _cache?.get(key) as List?;
    if (raw == null) return [];
    return raw.map((e) => MovieDto.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveSearch(String q, List<MovieDto> list) async {
    final key = keyForQuery(q);
    await _cache?.put(key, list.map((e) => e.toJson()).toList());
    await _cache?.put('$_kTimePrefix$key', DateTime.now().millisecondsSinceEpoch);
  }

  bool isSearchFresh(String q) => _isFresh(keyForQuery(q));

  Future<void> toggleFavorite(MovieDto dto) async {
    if (_fav.containsKey(dto.id)) {
      await _fav.delete(dto.id);
    } else {
      await _fav.put(dto.id, dto.toJson());
    }
    _emitFav();
  }

  Future<bool> isFavorite(int id) async => _fav.containsKey(id);

  Stream<List<MovieDto>> watchFavorites() => _favStream.stream;

  void _emitFav() {
    final list = _fav.values.map((e) => MovieDto.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    _favStream.add(list);
  }
}
