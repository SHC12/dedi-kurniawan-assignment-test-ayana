import 'package:hive/hive.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../../core/network.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/favorites_movie_local_ds.dart';
import '../datasources/local_cache_ds.dart';
import '../datasources/tmdb_remote_ds.dart';
import '../models/movie_detail_dto.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbRemoteDataSource remote;
  final LocalCacheDataSource local;
  final NetworkInfo networkInfo;
  final FavoritesMovieLocalDataSource favoritesLocal;

  MovieRepositoryImpl(this.favoritesLocal, {required this.remote, required this.local, required this.networkInfo});

  Future<void> _ensureInit() => local.init();

  static const _movieDetailBox = 'cache_movie_detail';
  static const _ttlMinDetail = 1440;

  Future<Box> _openMovieDetailBox() async =>
      Hive.isBoxOpen(_movieDetailBox) ? Hive.box(_movieDetailBox) : await Hive.openBox(_movieDetailBox);

  bool _fresh(int? ts) {
    if (ts == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - ts < Duration(minutes: _ttlMinDetail).inMilliseconds;
  }

  @override
  Future<Result<Failure, Movie>> getDetail(int id) async {
    final box = await _openMovieDetailBox();
    final key = 'movie_detail_$id';
    final tsKey = '${key}_ts';

    final ts = box.get(tsKey) as int?;
    if (_fresh(ts)) {
      final raw = box.get(key);
      if (raw is Map) {
        final dto = MovieDetailDto.fromJson(Map<String, dynamic>.from(raw));
        return Ok(dto.toEntity());
      }
    }

    try {
      final remoteEntity = await remote.getDetail(id);
      await box.put(key, MovieDetailDto.fromEntity(remoteEntity).toJson());
      await box.put(tsKey, DateTime.now().millisecondsSinceEpoch);
      return Ok(remoteEntity);
    } catch (e) {
      final raw = box.get(key);
      if (raw is Map) {
        final dto = MovieDetailDto.fromJson(Map<String, dynamic>.from(raw));
        return Ok(dto.toEntity());
      }
      return Err(ServerFailure('Failed to load movie detail: $e'));
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> getPopular({bool forceRefresh = false}) async {
    await _ensureInit();
    try {
      if (!forceRefresh && local.isPopularFresh()) {
        final cached = await local.getPopularCached();
        if (cached.isNotEmpty) return Ok(cached.map((e) => e.toEntity()).toList());
      }
      if (!await networkInfo.isConnected) {
        final cached = await local.getPopularCached();
        if (cached.isNotEmpty) return Ok(cached.map((e) => e.toEntity()).toList());
        return Err(NetworkFailure('No internet connection'));
      }
      final res = await remote.getPopular();
      await local.savePopular(res);
      return Ok(res.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> searchMovies(String query, {bool forceRefresh = false}) async {
    await _ensureInit();
    try {
      if (!forceRefresh && local.isSearchFresh(query)) {
        final cached = await local.getSearchCached(query);
        if (cached.isNotEmpty) return Ok(cached.map((e) => e.toEntity()).toList());
      }
      if (!await networkInfo.isConnected) {
        final cached = await local.getSearchCached(query);
        if (cached.isNotEmpty) return Ok(cached.map((e) => e.toEntity()).toList());
        return Err(NetworkFailure('No internet connection'));
      }
      final res = await remote.searchMovies(query);
      await local.saveSearch(query, res);
      return Ok(res.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, void>> toggleFavorite(Movie m) async {
    try {
      final exists = await favoritesLocal.exists(m.id);
      if (exists) {
        await favoritesLocal.delete(m.id);
      } else {
        await favoritesLocal.put(m);
      }
      return Ok(null);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Failure, bool>> isFavorite(int id) async {
    try {
      final ok = await favoritesLocal.exists(id);
      return Ok(ok);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Movie>> watchFavorites() => favoritesLocal.watchAll();

  @override
  Future<Result<Failure, List<Movie>>> getFavorites() async {
    try {
      final list = await favoritesLocal.getAll();
      return Ok(list);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }
}
