import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/favorite_item.dart';
import '../../../domain/entities/media_kind.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/usecases/favorites_movie.dart';
import '../../../domain/usecases/favorites_tv.dart';

class FavoritesCubit extends Cubit<List<FavoriteItem>> {
  final FavoritesMovie watchMovies;
  final FavoritesTv watchTv;

  StreamSubscription? _subM;
  StreamSubscription? _subT;

  List<Movie> _movies = const [];
  List<TvDetail> _tvs = const [];

  FavoritesCubit(this.watchMovies, this.watchTv) : super(const []) {
    _subM = watchMovies().listen((m) {
      _movies = m;
      _emitCombined();
    });
    _subT = watchTv().listen((t) {
      _tvs = t;
      _emitCombined();
    });
  }

  void _emitCombined() {
    final items = <FavoriteItem>[
      for (final m in _movies)
        FavoriteItem(
          id: m.id,
          kind: MediaKind.movie,
          title: m.title,
          posterPath: m.posterPath,
          vote: m.voteAverage,
          year: (m.releaseDate?.isNotEmpty ?? false) ? m.releaseDate!.substring(0, 4) : null,
        ),
      for (final t in _tvs)
        FavoriteItem(
          id: t.id,
          kind: MediaKind.tv,
          title: t.name,
          posterPath: t.posterPath,
          vote: t.voteAverage,
          year: (t.firstAirDate?.isNotEmpty ?? false) ? t.firstAirDate!.substring(0, 4) : null,
        ),
    ];

    items.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    emit(items);
  }

  @override
  Future<void> close() async {
    await _subM?.cancel();
    await _subT?.cancel();
    return super.close();
  }
}
