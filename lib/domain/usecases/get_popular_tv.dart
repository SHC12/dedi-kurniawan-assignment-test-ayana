import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/tv_show.dart';
import '../repositories/tv_repository.dart';

class GetPopularTv {
  final TvRepository repo;
  GetPopularTv(this.repo);
  Future<Result<Failure, List<TvShow>>> call() => repo.getPopularTv();
}
