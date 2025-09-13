import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repo;
  SearchMovies(this.repo);
  Future<Result<Failure, List<Movie>>> call(String query, {bool forceRefresh = false}) => repo.searchMovies(query, forceRefresh: forceRefresh);
}
