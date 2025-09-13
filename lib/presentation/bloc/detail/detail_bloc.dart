import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../../../domain/entities/detail_vm.dart';
import '../../../domain/entities/media_kind.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/is_favorite_tv.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import '../../../domain/usecases/is_favorite.dart';
import '../../../domain/usecases/toggle_favorite_tv.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail getMovieDetail;
  final GetTvDetail getTvDetail;
  final ToggleFavorite toggleFavorite;
  final IsFavorite isFavorite;
  final ToggleFavoriteTv toggleFavoriteTv;
  final IsFavoriteTv isFavoriteTv;

  DetailBloc(
    this.getMovieDetail,
    this.toggleFavorite,
    this.isFavorite,
    this.getTvDetail,
    this.toggleFavoriteTv,
    this.isFavoriteTv,
  ) : super(const DetailLoading()) {
    on<LoadDetail>((e, emit) async {
      emit(const DetailLoading());

      if (e.kind == MediaKind.movie) {
        final res = await getMovieDetail(e.id);

        if (res is Ok) {
          final m = (res as Ok).value as Movie;
          final vm = DetailVM(
            id: m.id,
            kind: MediaKind.movie,
            title: m.title,
            overview: m.overview,
            posterPath: m.posterPath,
            backdropPath: m.backdropPath,
            vote: m.voteAverage,
            year: (m.releaseDate?.isNotEmpty ?? false) ? m.releaseDate!.substring(0, 4) : null,
            genres: const [],
          );

          bool fav = false;
          final favRes = await isFavorite(m.id);
          if (favRes is Ok) fav = (favRes as Ok).value as bool;

          if (emit.isDone) return;
          emit(DetailLoaded(vm: vm, isFavorite: fav));
        } else {
          final f = (res as Err<Failure, dynamic>).failure;
          emit(DetailError(f.message));
        }
      } else {
        final res = await getTvDetail(e.id);

        if (res is Ok) {
          final d = (res as Ok).value as TvDetail;
          final vm = DetailVM(
            id: d.id,
            kind: MediaKind.tv,
            title: d.name,
            overview: d.overview,
            posterPath: d.posterPath,
            backdropPath: d.backdropPath,
            vote: d.voteAverage,
            year: (d.firstAirDate?.isNotEmpty ?? false) ? d.firstAirDate!.substring(0, 4) : null,
            genres: d.genres,
          );
          bool fav = false;
          final favRes = await isFavoriteTv(d.id);
          if (favRes is Ok) fav = (favRes as Ok).value as bool;
          if (emit.isDone) return;
          emit(DetailLoaded(vm: vm, isFavorite: fav));
        } else {
          final f = (res as Err<Failure, dynamic>).failure;
          emit(DetailError(f.message));
        }
      }
    });

    on<ToggleFavoriteEvent>((e, emit) async {
      final cur = state;
      if (cur is DetailLoaded) {
        if (cur.vm.kind == MediaKind.movie) {
          final movie = Movie(
            id: cur.vm.id,
            title: cur.vm.title,
            overview: cur.vm.overview,
            posterPath: cur.vm.posterPath,
            backdropPath: cur.vm.backdropPath,
            voteAverage: cur.vm.vote,
            releaseDate: cur.vm.year,
          );

          await toggleFavorite(movie);

          final favRes = await isFavorite(cur.vm.id);
          final fav = favRes is Ok ? (favRes as Ok).value as bool : cur.isFavorite;

          if (emit.isDone) return;
          emit(DetailLoaded(vm: cur.vm, isFavorite: fav));
        } else {
          final tv = TvDetail(
            id: cur.vm.id,
            name: cur.vm.title,
            overview: cur.vm.overview,
            posterPath: cur.vm.posterPath,
            backdropPath: cur.vm.backdropPath,
            voteAverage: cur.vm.vote,
            firstAirDate: cur.vm.year,
            genreIds: const [],
            genres: cur.vm.genres,
          );
          await toggleFavoriteTv(tv);
          final favRes = await isFavoriteTv(cur.vm.id);
          final fav = favRes is Ok ? (favRes as Ok).value as bool : cur.isFavorite;

          if (emit.isDone) return;
          emit(DetailLoaded(vm: cur.vm, isFavorite: fav));
        }
      }
    });
  }
}
