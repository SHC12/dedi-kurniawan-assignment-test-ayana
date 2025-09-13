import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repo;
  GetMovieDetail(this.repo);
  Future<Result<Failure, Movie>> call(int id) => repo.getDetail(id);
}
