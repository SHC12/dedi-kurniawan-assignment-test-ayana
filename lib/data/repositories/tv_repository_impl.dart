import 'package:hive_flutter/hive_flutter.dart';
import '../../core/result.dart';
import '../../core/failure.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/repositories/tv_repository.dart';
import '../datasources/favorites_tv_local_ds.dart';
import '../datasources/tmdb_remote_ds.dart';
import '../models/tv_detail_dto.dart';
import '../models/tv_dto.dart';

class TvRepositoryImpl implements TvRepository {
  final TmdbRemoteDataSource remote;
  final FavoritesTvLocalDataSource favTvLocal;

  TvRepositoryImpl(this.remote, this.favTvLocal);

  static const _box = 'cache_tv';
  static const _keyPopular = 'popular_tv';
  static const _keyTs = 'popular_tv_ts';
  static const _ttlMin = 30;

  static const _detailBox = 'cache_tv_detail';
  static const _ttlMinDetail = 1440;

  Future<Box> _open() async => Hive.isBoxOpen(_box) ? Hive.box(_box) : await Hive.openBox(_box);
  Future<Box> _openDetailBox() async =>
      Hive.isBoxOpen(_detailBox) ? Hive.box(_detailBox) : await Hive.openBox(_detailBox);

  bool _fresh(int? ts) {
    if (ts == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - ts < Duration(minutes: _ttlMin).inMilliseconds;
  }

  bool _freshDetail(int? ts) {
    if (ts == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - ts < Duration(minutes: _ttlMinDetail).inMilliseconds;
  }

  @override
  Future<Result<Failure, TvDetail>> getTvDetail(int id) async {
    final box = await _openDetailBox();
    final key = 'tv_detail_$id';
    final keyTs = '${key}_ts';

    final ts = box.get(keyTs) as int?;
    if (_freshDetail(ts)) {
      final raw = box.get(key);
      if (raw is Map) {
        final dto = TvDetailDto.fromJson(Map<String, dynamic>.from(raw));
        return Ok(dto.toEntity());
      }
    }

    try {
      final data = await remote.fetchTvDetail(id);
      await box.put(key, TvDetailDto.fromEntity(data).toJson());
      await box.put(keyTs, DateTime.now().millisecondsSinceEpoch);
      return Ok(data);
    } catch (e) {
      final raw = box.get(key);
      if (raw is Map) {
        final dto = TvDetailDto.fromJson(Map<String, dynamic>.from(raw));
        return Ok(dto.toEntity());
      }
      return Err(ServerFailure('Failed to load TV detail: $e'));
    }
  }

  @override
  Future<Result<Failure, List<TvShow>>> getPopularTv() async {
    final box = await _open();

    final ts = box.get(_keyTs) as int?;
    if (_fresh(ts)) {
      final raw = (box.get(_keyPopular) as List?)?.cast<Map>() ?? const [];
      if (raw.isNotEmpty) {
        final data = raw.map((e) => TvDto.fromJson(Map<String, dynamic>.from(e)).toEntity()).toList();
        return Ok(data);
      }
    }

    try {
      final data = await remote.fetchPopularTv();
      await box.put(_keyPopular, data.map((e) => TvDto.fromEntity(e).toJson()).toList());
      await box.put(_keyTs, DateTime.now().millisecondsSinceEpoch);
      return Ok(data);
    } catch (e) {
      final raw = (box.get(_keyPopular) as List?)?.cast<Map>() ?? const [];
      if (raw.isNotEmpty) {
        final data = raw.map((e) => TvDto.fromJson(Map<String, dynamic>.from(e)).toEntity()).toList();
        return Ok(data);
      }
      return Err(ServerFailure('Failed to load TV Popular: $e'));
    }
  }

  @override
  Future<Result<Failure, void>> toggleFavoriteTv(TvDetail tv) async {
    try {
      final exists = await favTvLocal.exists(tv.id);
      if (exists) {
        await favTvLocal.delete(tv.id);
      } else {
        await favTvLocal.put(tv);
      }
      return Ok(null);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, bool>> isFavoriteTv(int id) async {
    try {
      final ok = await favTvLocal.exists(id);
      return Ok(ok);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<TvDetail>> watchFavoritesTv() => favTvLocal.watchAll();

  @override
  Future<Result<Failure, List<TvDetail>>> getFavoritesTv() async {
    try {
      final list = await favTvLocal.getAll();
      return Ok(list);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }
}
