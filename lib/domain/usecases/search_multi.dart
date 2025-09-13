import 'package:ayana_movies/core/failure.dart';

import '../entities/media.dart';
import '../repositories/explore_repository.dart';
import '../../core/result.dart';

class SearchMulti {
  final ExploreRepository repo;
  SearchMulti(this.repo);
  Future<Result<Failure, List<Media>>> call(String q) => repo.searchMulti(q);
}
