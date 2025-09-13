import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class FavoritesTv {
  final TvRepository repo;
  FavoritesTv(this.repo);
  Stream<List<TvDetail>> call() => repo.watchFavoritesTv();
}
