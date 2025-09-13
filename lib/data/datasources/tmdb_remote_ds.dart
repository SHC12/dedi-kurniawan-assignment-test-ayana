import 'package:dio/dio.dart';
import '../../core/config.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/entities/tv_show.dart';
import '../models/media_dto.dart';
import '../models/movie_detail_dto.dart';
import '../models/movie_dto.dart';
import '../models/tv_detail_dto.dart';
import '../models/tv_dto.dart';

class TmdbRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kTmdbBaseUrl,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $kTmdbApiKey'},
    ),
  );

  Future<List<MovieDto>> getPopular({int page = 1}) async {
    final res = await _dio.get('/movie/popular', queryParameters: {'page': page});
    return MovieDto.listFromJson(res.data['results'] as List);
  }

  Future<List<MovieDto>> getTopTenWeek({int page = 1}) async {
    final res = await _dio.get('/trending/movie/week', queryParameters: {'page': page});
    return MovieDto.listFromJson(res.data['results'] as List);
  }

  Future<List<MovieDto>> searchMovies(String query, {int page = 1}) async {
    final res = await _dio.get(
      '/search/movie',
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );
    return MovieDto.listFromJson(res.data['results'] as List);
  }

  Future<Movie> getDetail(int id, {String? language}) async {
    final resp = await _dio.get(
      '$kTmdbBaseUrl/movie/$id',
      queryParameters: {'api_key': kTmdbApiKey, if (language != null) 'language': language},
    );
    final json = Map<String, dynamic>.from(resp.data as Map);
    final dto = MovieDetailDto.fromJson(json);
    return dto.toEntity();
  }

  Future<List<Media>> fetchTrendingAll() async {
    final r = await _dio.get('$kTmdbBaseUrl/trending/all/week', queryParameters: {'api_key': kTmdbApiKey});
    final list = (r.data['results'] as List).map((e) => MediaDto.fromJson(e).toEntity()).toList();
    return list.where((m) => m.mediaType == 'movie' || m.mediaType == 'tv').toList();
  }

  Future<List<TvShow>> fetchPopularTv() async {
    final r = await _dio.get('$kTmdbBaseUrl/tv/popular');
    final results = (r.data['results'] as List?) ?? const [];
    return results.map((e) => TvDto.fromJson(Map<String, dynamic>.from(e)).toEntity()).toList();
  }

  Future<TvDetail> fetchTvDetail(int id) async {
    final r = await _dio.get('$kTmdbBaseUrl/tv/$id', queryParameters: {'api_key': kTmdbApiKey});
    return TvDetailDto.fromJson(Map<String, dynamic>.from(r.data)).toEntity();
  }

  Future<List<Media>> searchMulti(String q) async {
    final r = await _dio.get(
      '$kTmdbBaseUrl/search/multi',
      queryParameters: {'api_key': kTmdbApiKey, 'query': q, 'include_adult': false},
    );
    final list = (r.data['results'] as List).map((e) => MediaDto.fromJson(e).toEntity()).toList();
    return list.where((m) => m.mediaType == 'movie' || m.mediaType == 'tv').toList();
  }
}
