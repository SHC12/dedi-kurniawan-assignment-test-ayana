import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config.dart';
import '../../../../domain/entities/movie.dart';
import 'cached_image.dart';

class PosterCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String imdb;
  final VoidCallback? onTap;

  const PosterCard({super.key, required this.imageUrl, required this.title, required this.imdb, this.onTap});

  factory PosterCard.fromMovie(Movie m, {VoidCallback? onTap}) {
    final poster = m.posterPath != null ? '$kTmdbImageBaseUrl${m.posterPath}' : '';
    final rating = (m.voteAverage ?? 0).toStringAsFixed(1);
    return PosterCard(imageUrl: poster, title: m.title, imdb: rating, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 40.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: imageUrl.isEmpty
                    ? Container(color: dimColor)
                    : AppCachedImage(pathOrUrl: imageUrl, fit: BoxFit.cover),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 110,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, bgColor.withValues(alpha: 0.65)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(color: yellowColor, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Text('IMDb', style: defaultSubBoldBlackTextStyle),
                      SizedBox(width: 1.w),
                      Text(imdb, style: defaultSubBoldBlackTextStyle),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: defaultSubBoldWhiteTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
