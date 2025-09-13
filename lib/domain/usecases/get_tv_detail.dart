import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class GetTvDetail {
  final TvRepository repo;
  GetTvDetail(this.repo);
  Future<Result<Failure, TvDetail>> call(int id) => repo.getTvDetail(id);
}
