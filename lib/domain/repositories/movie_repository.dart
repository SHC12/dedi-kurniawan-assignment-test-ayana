import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Result<Failure, List<Movie>>> getPopular({bool forceRefresh = false});
  Future<Result<Failure, List<Movie>>> searchMovies(String query, {bool forceRefresh = false});
  Future<Result<Failure, Movie>> getDetail(int id);
  Future<Result<Failure, void>> toggleFavorite(Movie movie);
  Future<Result<Failure, bool>> isFavorite(int id);

  Stream<List<Movie>> watchFavorites();
  Future<Result<Failure, List<Movie>>> getFavorites();
}
