import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class ToggleFavoriteTv {
  final TvRepository repo;
  ToggleFavoriteTv(this.repo);
  Future<Result<Failure, void>> call(TvDetail tv) => repo.toggleFavoriteTv(tv);
}
