import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:ayana_movies/presentation/screens/home/tv_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/config.dart';
import '../../../bloc/tv/tv_bloc.dart';
import '../../../l10n/l10n.dart';
import '../../../../domain/entities/media_kind.dart';
import '../../detail/detail_screen.dart';
import '../../shared/widgets/poster_card.dart';

class PopularTVSection extends StatelessWidget {
  const PopularTVSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context).t;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
          child: Row(
            children: [
              Expanded(child: Text(t('popular_tv'), style: defaultBigWhiteTextStyle)),
              TextButton(
                onPressed: () {
                  final tvBloc = context.read<TvBloc>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: tvBloc,
                        child: TVScreen(title: t('popular_tv')),
                      ),
                    ),
                  );
                },
                child: Text(t('see_all'), style: defaultSubDimTextStyle),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: BlocBuilder<TvBloc, TvState>(
            builder: (context, state) {
              if (state is TvLoading) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => Container(
                    width: 160,
                    decoration: BoxDecoration(color: const Color(0xFF141A23), borderRadius: BorderRadius.circular(18)),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 6,
                );
              }
              if (state is TvError) {
                return Center(
                  child: Text(state.message, style: const TextStyle(color: Colors.white70)),
                );
              }
              final items = (state as TvLoaded).items;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final tv = items[i];
                  final poster = tv.posterPath != null ? '$kTmdbImageBaseUrl${tv.posterPath}' : '';
                  final imdb = (tv.voteAverage ?? 0).toStringAsFixed(1);
                  return PosterCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(id: tv.id, kind: MediaKind.tv),
                        ),
                      );
                    },
                    imageUrl: poster,
                    title: tv.name,
                    imdb: imdb,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: items.length.clamp(0, 10),
              );
            },
          ),
        ),
      ],
    );
  }
}
