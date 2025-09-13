import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/presentation/screens/explore/widgets/active_chip_filter.dart';
import 'package:ayana_movies/presentation/screens/explore/widgets/explore_skeleton.dart';
import 'package:ayana_movies/presentation/screens/explore/widgets/search_filter.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/error_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/not_found_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/poster_card.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config.dart';
import '../../../core/di.dart';
import '../../../domain/usecases/get_trending_media.dart';
import '../../../domain/usecases/search_multi.dart';
import '../../bloc/explore/explore_bloc.dart';
import '../../../domain/entities/media_kind.dart';
import '../detail/detail_screen.dart';
import '../../../domain/entities/media.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const bg = Color(0xFF0B0E14);
  static const card = Color(0xFF141A23);
  static const textDim = Color(0xFFB7C0CE);
  void _openDetail(BuildContext context, int id, MediaKind kind) async {
    final f = FocusManager.instance.primaryFocus;
    if (f != null && f.hasFocus) f.unfocus();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(id: id, kind: kind),
      ),
    );
    Future.microtask(() => FocusManager.instance.primaryFocus?.unfocus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreBloc(sl<GetTrendingMedia>(), sl<SearchMulti>())..add(const ExploreStarted()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: Column(
                children: [
                  SearchFilter(),

                  ActiveChipFilter(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<ExploreBloc, ExploreState>(
                      builder: (context, state) {
                        if (state is ExploreLoading) {
                          return const ExploreSkeleton();
                        }

                        if (state is ExploreSearching) {
                          return const ExploreSkeleton();
                        }

                        if (state is ExploreError) {
                          return ErrorView(
                            message: state.message,
                            onRetry: () => context.read<ExploreBloc>().add(const ExploreRetry()),
                          );
                        }
                        if (state is ExploreEmpty) {
                          return const NotFoundView();
                        }

                        if (state is ExploreLoaded) {
                          final items = state.results;
                          final hasQuery = state.query.isNotEmpty;

                          final movies = items.where((m) => m.mediaType == 'movie').toList();
                          final tvs = items.where((m) => m.mediaType == 'tv').toList();

                          return CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              if (!hasQuery) ...[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Text(context.t('recommendation_for_you'), style: defaultBigWhiteTextStyle),
                                  ),
                                ),

                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate((context, i) {
                                      final m = items[i];
                                      final poster = m.posterPath != null ? '$kTmdbImageBaseUrl${m.posterPath}' : '';
                                      final imdb = (m.voteAverage ?? 0).toStringAsFixed(1);

                                      return PosterCard(
                                        imageUrl: poster,
                                        title: m.title,
                                        imdb: imdb,
                                        onTap: () => _openDetail(
                                          context,
                                          m.id,
                                          m.mediaType == 'movie' ? MediaKind.movie : MediaKind.tv,
                                        ),
                                      );
                                    }, childCount: items.length),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.70,
                                    ),
                                  ),
                                ),
                                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                              ],

                              if (hasQuery) ...[
                                if (movies.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: _SectionRow(
                                      title: 'Movies',
                                      items: movies,
                                      onTapItem: (m) => _openDetail(context, m.id, MediaKind.movie),
                                    ),
                                  ),
                                if (tvs.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: _SectionRow(
                                      title: 'TV',
                                      items: tvs,
                                      onTapItem: (m) => _openDetail(context, m.id, MediaKind.tv),
                                    ),
                                  ),

                                if (movies.isEmpty && tvs.isEmpty) const SliverToBoxAdapter(child: NotFoundView()),

                                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                              ],
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final String title;
  final List<Media> items;
  final void Function(Media m) onTapItem;
  const _SectionRow({required this.title, required this.items, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 210,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final m = items[i];
                final poster = m.posterPath != null ? '$kTmdbImageBaseUrl${m.posterPath}' : '';
                final imdb = (m.voteAverage ?? 0).toStringAsFixed(1);
                return PosterCard(imageUrl: poster, title: m.title, imdb: imdb, onTap: () => onTapItem(m));
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: items.length > 10 ? 10 : items.length,
            ),
          ),
        ],
      ),
    );
  }
}
