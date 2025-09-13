import 'package:ayana_movies/core/failure.dart';

import '../entities/media.dart';
import '../repositories/explore_repository.dart';
import '../../core/result.dart';

class GetTrendingMedia {
  final ExploreRepository repo;
  GetTrendingMedia(this.repo);
  Future<Result<Failure, List<Media>>> call() => repo.getTrendingAll();
}
