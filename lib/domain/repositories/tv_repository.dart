import '../../core/result.dart';
import '../../core/failure.dart';
import '../entities/tv_detail.dart';
import '../entities/tv_show.dart';

abstract class TvRepository {
  Future<Result<Failure, List<TvShow>>> getPopularTv();
  Future<Result<Failure, TvDetail>> getTvDetail(int id);

  Future<Result<Failure, void>> toggleFavoriteTv(TvDetail tv);
  Future<Result<Failure, bool>> isFavoriteTv(int id);
  Stream<List<TvDetail>> watchFavoritesTv();
  Future<Result<Failure, List<TvDetail>>> getFavoritesTv();
}
