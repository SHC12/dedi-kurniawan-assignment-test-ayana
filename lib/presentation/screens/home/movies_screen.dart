import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/empty_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/error_view.dart';
import 'package:ayana_movies/presentation/screens/shared/widgets/poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/config.dart';
import '../../../core/theme/typhography.dart';
import '../../../domain/entities/movie.dart';
import '../../bloc/movie_list/movie_list_bloc.dart';

class MoviesScreen extends StatelessWidget {
  final String title;
  const MoviesScreen({super.key, required this.title});

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
      body: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          if (state is MovieListLoading || state is MovieListInitial) {
            return const _GridSkeleton();
          }
          if (state is MovieListError) {
            return ErrorView(message: state.message, onRetry: () => Navigator.pop(context));
          }
          final movies = (state as MovieListLoaded).movies;

          if (movies.isEmpty) {
            return const EmptyView();
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.w),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (_, i) => _MovieCard(m: movies[i]),
            ),
          );
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie m;
  const _MovieCard({required this.m});

  @override
  Widget build(BuildContext context) {
    final poster = m.posterPath != null ? '$kTmdbImageBaseUrl${m.posterPath}' : null;
    final imdb = (m.voteAverage ?? 0).toStringAsFixed(1);

    return PosterCard(imageUrl: poster!, title: m.title, imdb: imdb);
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
