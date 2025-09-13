import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repo;
  GetPopularMovies(this.repo);
  Future<Result<Failure, List<Movie>>> call({bool forceRefresh = false}) => repo.getPopular(forceRefresh: forceRefresh);
}
