import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class FavoritesMovie {
  final MovieRepository repo;
  FavoritesMovie(this.repo);
  Stream<List<Movie>> call() => repo.watchFavorites();
}
