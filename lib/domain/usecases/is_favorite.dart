import '../../core/result.dart';
import '../../core/failure.dart';
import '../repositories/movie_repository.dart';

class IsFavorite {
  final MovieRepository repo;
  IsFavorite(this.repo);
  Future<Result<Failure, bool>> call(int id) => repo.isFavorite(id);
}
