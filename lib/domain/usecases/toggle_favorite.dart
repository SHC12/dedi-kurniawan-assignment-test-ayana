import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite {
  final MovieRepository repo;
  ToggleFavorite(this.repo);
  Future<Result<Failure, void>> call(Movie m) => repo.toggleFavorite(m);
}
