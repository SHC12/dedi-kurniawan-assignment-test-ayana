import 'package:ayana_movies/presentation/screens/shared/widgets/empty_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/error_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typhography.dart';
import '../../../domain/entities/tv_show.dart';
import '../../bloc/tv/tv_bloc.dart';

class TVScreen extends StatelessWidget {
  final String title;
  const TVScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(title, style: defaultBigWhiteTextStyle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<TvBloc, TvState>(
        builder: (context, state) {
          if (state is TvLoading) {
            return const _GridSkeleton();
          }
          if (state is TvError) {
            return ErrorView(message: state.message, onRetry: () => Navigator.pop(context));
          }
          final tvs = (state as TvLoaded).items;

          if (tvs.isEmpty) return const EmptyView();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tvs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (_, i) => _TvCard(tv: tvs[i]),
            ),
          );
        },
      ),
    );
  }
}

class _TvCard extends StatelessWidget {
  final TvShow tv;
  const _TvCard({required this.tv});

  @override
  Widget build(BuildContext context) {
    final poster = tv.posterPath != null ? '$kTmdbImageBaseUrl${tv.posterPath}' : null;
    final imdb = (tv.voteAverage ?? 0).toStringAsFixed(1);

    return PosterCard(imageUrl: poster!, title: tv.name, imdb: imdb);
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
