import 'package:ayana_movies/core/prefs.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/favorites_movie_local_ds.dart';
import '../data/datasources/favorites_tv_local_ds.dart';
import '../data/datasources/tmdb_remote_ds.dart';
import '../data/datasources/local_cache_ds.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/tv_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/tv_repository.dart';
import '../domain/usecases/get_popular_movies.dart';
import '../domain/usecases/get_popular_tv.dart';
import '../domain/usecases/get_tv_detail.dart';
import '../domain/usecases/is_favorite_tv.dart';
import '../domain/usecases/search_movies.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/toggle_favorite.dart';
import '../domain/usecases/is_favorite.dart';
import '../domain/usecases/toggle_favorite_tv.dart';
import '../domain/usecases/favorites_movie.dart';
import '../data/repositories/explore_repository_impl.dart';
import '../domain/repositories/explore_repository.dart';
import '../domain/usecases/get_trending_media.dart';
import '../domain/usecases/search_multi.dart';
import '../domain/usecases/favorites_tv.dart';
import '../presentation/bloc/settings/language_cubit.dart';
import 'network.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<Prefs>(() => Prefs());
  sl.registerFactory(() => LanguageCubit());

  sl.registerLazySingleton<TmdbRemoteDataSource>(() => TmdbRemoteDataSource());
  sl.registerLazySingleton<LocalCacheDataSource>(() => LocalCacheDataSource());

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl(), sl<FavoritesMovieLocalDataSource>()),
  );
  sl.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(sl<TmdbRemoteDataSource>(), sl<FavoritesTvLocalDataSource>()),
  );
  sl.registerLazySingleton<FavoritesTvLocalDataSource>(() => FavoritesTvLocalDataSource());
  sl.registerLazySingleton<FavoritesTv>(() => FavoritesTv(sl<TvRepository>()));
  sl.registerLazySingleton<ToggleFavoriteTv>(() => ToggleFavoriteTv(sl<TvRepository>()));
  sl.registerLazySingleton<IsFavoriteTv>(() => IsFavoriteTv(sl<TvRepository>()));

  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(sl<TmdbRemoteDataSource>(), sl<LocalCacheDataSource>()),
  );

  sl.registerLazySingleton(() => GetTvDetail(sl<TvRepository>()));
  sl.registerLazySingleton(() => GetPopularTv(sl<TvRepository>()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => FavoritesMovieLocalDataSource());
  sl.registerLazySingleton(() => IsFavorite(sl()));
  sl.registerLazySingleton(() => FavoritesMovie(sl()));
  sl.registerLazySingleton(() => GetTrendingMedia(sl()));
  sl.registerLazySingleton(() => SearchMulti(sl()));
}
