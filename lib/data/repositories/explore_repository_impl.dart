import 'package:ayana_movies/data/datasources/local_cache_ds.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/result.dart';
import '../../core/failure.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/tmdb_remote_ds.dart';
import '../models/media_dto.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final TmdbRemoteDataSource remote;
  ExploreRepositoryImpl(this.remote, LocalCacheDataSource localCacheDataSource);

  static const _boxName = 'cache_explore';
  static const _kTrendingKey = 'trending_all_week';
  static const _kTrendingTs = 'trending_all_week_ts';
  static const _ttlMinutes = 30;

  Future<Box> _box() async => await Hive.openBox(_boxName);

  bool _fresh(int? tsMs) {
    if (tsMs == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - tsMs) < Duration(minutes: _ttlMinutes).inMilliseconds;
  }

  @override
  Future<Result<Failure, List<Media>>> getTrendingAll() async {
    final box = await _box();

    final ts = box.get(_kTrendingTs) as int?;
    if (_fresh(ts)) {
      final cached = (box.get(_kTrendingKey) as List?)?.cast<Map>() ?? const [];
      if (cached.isNotEmpty) {
        final data = cached.map((e) => MediaDto.fromJson(Map<String, dynamic>.from(e)).toEntity()).toList();
        return Ok(data);
      }
    }

    try {
      final data = await remote.fetchTrendingAll();
      await box.put(_kTrendingKey, data.map((m) => MediaDto.fromEntity(m).toJson()).toList());
      await box.put(_kTrendingTs, DateTime.now().millisecondsSinceEpoch);
      return Ok(data);
    } catch (e) {
      final cached = (box.get(_kTrendingKey) as List?)?.cast<Map>() ?? const [];
      if (cached.isNotEmpty) {
        final data = cached.map((e) => MediaDto.fromJson(Map<String, dynamic>.from(e)).toEntity()).toList();
        return Ok(data);
      }
      return Err(ServerFailure('Failed to load trending: $e'));
    }
  }

  @override
  Future<Result<Failure, List<Media>>> searchMulti(String q) async {
    try {
      final data = await remote.searchMulti(q);
      return Ok(data);
    } catch (e) {
      return Err(ServerFailure('Failed to search: $e'));
    }
  }
}
