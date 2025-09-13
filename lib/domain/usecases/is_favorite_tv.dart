import '../../core/result.dart';
import '../../core/failure.dart';
import '../repositories/tv_repository.dart';

class IsFavoriteTv {
  final TvRepository repo;
  IsFavoriteTv(this.repo);
  Future<Result<Failure, bool>> call(int id) => repo.isFavoriteTv(id);
}
