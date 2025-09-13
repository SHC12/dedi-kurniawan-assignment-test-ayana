import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/favorite_item.dart';
import '../../../domain/entities/media_kind.dart';
import '../../../domain/usecases/favorites_movie.dart';
import '../../../domain/usecases/favorites_tv.dart';
import '../../bloc/favorites/favorites_cubit.dart';
import '../detail/detail_screen.dart';
import '../shared/widgets/cached_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const bg = Color(0xFF0B0E14);
  static const badgeTv = Color(0xFF00D4FF);
  static const badgeMovie = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit(sl<FavoritesMovie>(), sl<FavoritesTv>()),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Text(context.t('my_favorites'), style: defaultBigWhiteTextStyle),
        ),
        body: BlocBuilder<FavoritesCubit, List<FavoriteItem>>(
          builder: (_, items) {
            if (items.isEmpty) return const _EmptyView();

            return GridView.builder(
              padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _FavCard(item: items[i]),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, color: greyColor, size: 48),
            SizedBox(height: 12),
            Text(context.t('no_favorites'), style: defaultDimTextStyle),
            SizedBox(height: 6),
            Text(context.t('save_it_here'), style: defaultDimTextStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final FavoriteItem item;
  const _FavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final poster = item.posterPath != null ? '$kTmdbImageBaseUrl${item.posterPath}' : null;
    final imdb = (item.vote ?? 0).toStringAsFixed(1);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(id: item.id, kind: item.kind),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: poster == null
                  ? Container(color: Colors.white10)
                  : AppCachedImage(pathOrUrl: poster, fit: BoxFit.cover),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.kind == MediaKind.movie ? FavoritesScreen.badgeMovie : FavoritesScreen.badgeTv,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.kind == MediaKind.movie ? context.t('movie') : 'TV',
                        style: defaultSubBoldWhiteTextStyle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text('IMDb', style: defaultSubBoldWhiteTextStyle),
                    SizedBox(width: 1.w),
                    Text(imdb, style: defaultSubBoldWhiteTextStyle),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: defaultSubBoldWhiteTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
