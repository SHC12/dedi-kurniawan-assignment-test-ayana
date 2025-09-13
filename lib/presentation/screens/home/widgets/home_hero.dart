import 'package:ayana_movies/presentation/screens/shared/widgets/chip_border_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config.dart';
import '../../../../domain/entities/movie.dart';
import '../../../l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typhography.dart';
import '../../shared/widgets/cached_image.dart';

class HomeHero extends StatelessWidget {
  final List<Movie> movies;
  const HomeHero({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context).t;
    final hero = movies.isNotEmpty ? movies.first : null;
    final heroBackdrop = hero?.backdropPath != null
        ? '$kTmdbImageBaseUrl${hero!.backdropPath}'
        : 'https://images.unsplash.com/photo-1542362567-b07e54358753?q=80&w=1920&auto=format&fit=crop';

    String? year;
    if (hero?.releaseDate != null && hero!.releaseDate!.isNotEmpty) {
      year = hero.releaseDate!.substring(0, 4);
    }

    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppCachedImage(pathOrUrl: heroBackdrop, fit: BoxFit.cover, alignment: Alignment.topCenter),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgColor.withValues(alpha: 0.15), bgColor.withValues(alpha: 0.55), bgColor],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 30.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor.withValues(alpha: 0.10),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
                boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.30), blurRadius: 30, spreadRadius: 4)],
              ),
              child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 1.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 220),
                  Text(hero?.title ?? '—', textAlign: TextAlign.center, style: defaultBigWhiteTextStyle),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (year != null) ChipBorderColor(text: t('movie')),
                      if (year != null) ChipBorderColor(text: year),
                      if (hero?.voteAverage != null)
                        ChipBorderColor(text: '⭐ ${hero!.voteAverage!.toStringAsFixed(1)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 68,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (_, i) {
                        final m = movies[(i + 1) % movies.length];
                        final url = m.backdropPath ?? m.posterPath;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: url == null
                              ? Container(width: 110, height: 68, color: Colors.white10)
                              : AppCachedImage(
                                  pathOrUrl: '$kTmdbImageBaseUrl$url',
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 68,
                                ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: movies.length.clamp(0, 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
