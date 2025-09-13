import '../../core/failure.dart';
import '../entities/media.dart';
import '../../core/result.dart';

abstract class ExploreRepository {
  Future<Result<Failure, List<Media>>> getTrendingAll();
  Future<Result<Failure, List<Media>>> searchMulti(String q);
}
