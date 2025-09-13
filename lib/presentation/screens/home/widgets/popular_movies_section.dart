import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../domain/entities/movie.dart';
import '../../../bloc/movie_list/movie_list_bloc.dart';
import '../../../l10n/l10n.dart';
import '../../../../core/theme/typhography.dart';
import '../../../../domain/entities/media_kind.dart';
import '../../detail/detail_screen.dart';
import '../../shared/widgets/poster_card.dart';
import '../movies_screen.dart';

class PopularMoviesSection extends StatelessWidget {
  final List<Movie> movies;
  const PopularMoviesSection({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context).t;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 1.h, 2.w, 1.h),
          child: Row(
            children: [
              Expanded(child: Text(t('popular_movies'), style: defaultBigWhiteTextStyle)),
              TextButton(
                onPressed: () {
                  final moviesBloc = context.read<MovieListBloc>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: moviesBloc,
                        child: MoviesScreen(title: t('popular_movies')),
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
          height: 25.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final m = movies[i];
              return PosterCard.fromMovie(
                m,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(id: m.id, kind: MediaKind.movie),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: movies.length >= 10 ? 10 : movies.length,
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
}
