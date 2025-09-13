import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TmdbImageCache extends CacheManager {
  static const key = 'tmdb_image_cache';

  TmdbImageCache()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 1200,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  static final instance = TmdbImageCache();
}
