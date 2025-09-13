// ignore_for_file: one_member_abstracts
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_movies/domain/usecases/get_popular_tv.dart';
import 'package:ayana_movies/domain/usecases/search_movies.dart';
import 'package:ayana_movies/domain/usecases/get_movie_detail.dart';
import 'package:ayana_movies/domain/usecases/get_tv_detail.dart';
import 'package:ayana_movies/domain/usecases/is_favorite.dart';
import 'package:ayana_movies/domain/usecases/toggle_favorite.dart';
import 'package:ayana_movies/domain/usecases/is_favorite_tv.dart';
import 'package:ayana_movies/domain/usecases/toggle_favorite_tv.dart';
import 'package:ayana_movies/domain/usecases/get_trending_media.dart';
import 'package:ayana_movies/domain/usecases/search_multi.dart';
import 'package:ayana_movies/core/prefs.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}
class MockGetPopularTv extends Mock implements GetPopularTv {}
class MockSearchMovies extends Mock implements SearchMovies {}
class MockGetMovieDetail extends Mock implements GetMovieDetail {}
class MockGetTvDetail extends Mock implements GetTvDetail {}
class MockIsFavorite extends Mock implements IsFavorite {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}
class MockIsFavoriteTv extends Mock implements IsFavoriteTv {}
class MockToggleFavoriteTv extends Mock implements ToggleFavoriteTv {}
class MockGetTrendingMedia extends Mock implements GetTrendingMedia {}
class MockSearchMulti extends Mock implements SearchMulti {}
class MockPrefs extends Mock implements Prefs {}