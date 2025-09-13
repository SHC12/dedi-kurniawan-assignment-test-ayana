import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config.dart';
import '../../../../core/tmdb_image_cache.dart';

class AppCachedImage extends StatelessWidget {
  final String? pathOrUrl;
  final double? width, height;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadiusGeometry? radius;
  final Widget? placeholder;
  final Widget? error;

  const AppCachedImage({
    super.key,
    required this.pathOrUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.radius,
    this.placeholder,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (pathOrUrl == null || pathOrUrl!.isEmpty) {
      return _ph();
    }

    final url = pathOrUrl!.startsWith('http') ? pathOrUrl! : '$kTmdbImageBaseUrl$pathOrUrl';

    final img = CachedNetworkImage(
      imageUrl: url,
      cacheManager: TmdbImageCache.instance,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: (_, __) => _ph(),
      errorWidget: (_, __, ___) =>
          error ??
          Container(
            width: width,
            height: height,
            color: Colors.white10,
            child: const Icon(Icons.broken_image, color: Colors.white54, size: 20),
          ),
      fadeInDuration: const Duration(milliseconds: 180),
      fadeOutDuration: const Duration(milliseconds: 120),
      memCacheHeight: height?.toInt(),
      memCacheWidth: width?.toInt(),
    );

    if (radius != null) {
      return ClipPath(
        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: radius!)),
        child: img,
      );
    }
    return img;
  }

  Widget _ph() => placeholder ?? Container(width: width, height: height, color: Colors.white10);
}
