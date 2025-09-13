import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/detail/detail_bloc.dart';
import 'package:ayana_movies/domain/entities/media_kind.dart';
import 'package:ayana_movies/core/result.dart';
import 'package:ayana_movies/core/failure.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetTvDetail mockGetTvDetail;
  late MockIsFavorite mockIsFavorite;
  late MockToggleFavorite mockToggleFavorite;
  late MockIsFavoriteTv mockIsFavoriteTv;
  late MockToggleFavoriteTv mockToggleFavoriteTv;

  setUpAll(() {
    registerFallbackValue(tMovie);
    registerFallbackValue(tTvDetail);
  });

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetTvDetail = MockGetTvDetail();
    mockIsFavorite = MockIsFavorite();
    mockToggleFavorite = MockToggleFavorite();
    mockIsFavoriteTv = MockIsFavoriteTv();
    mockToggleFavoriteTv = MockToggleFavoriteTv();
  });

  DetailBloc buildBloc() => DetailBloc(
    mockGetMovieDetail,
    mockToggleFavorite,
    mockIsFavorite,
    mockGetTvDetail,
    mockToggleFavoriteTv,
    mockIsFavoriteTv,
  );

  blocTest<DetailBloc, DetailState>(
    'LoadDetail movie -> [Loading, Loaded]',
    build: () {
      when(() => mockGetMovieDetail(any())).thenAnswer((_) async => const Ok(tMovie));
      when(() => mockIsFavorite(any())).thenAnswer((_) async => const Ok(true));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadDetail(1, MediaKind.movie)),
    expect: () => [isA<DetailLoading>(), isA<DetailLoaded>()],
  );

  blocTest<DetailBloc, DetailState>(
    'LoadDetail tv -> [Loading, Loaded]',
    build: () {
      when(() => mockGetTvDetail(any())).thenAnswer((_) async => const Ok(tTvDetail));
      when(() => mockIsFavoriteTv(any())).thenAnswer((_) async => const Ok(false));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadDetail(101, MediaKind.tv)),
    expect: () => [isA<DetailLoading>(), isA<DetailLoaded>()],
  );

  blocTest<DetailBloc, DetailState>(
    'ToggleFavoriteEvent (movie)',
    build: () {
      when(() => mockGetMovieDetail(any())).thenAnswer((_) async => const Ok(tMovie));
      var calls = 0;
      when(() => mockIsFavorite(any())).thenAnswer((_) async => Ok(calls++ == 0 ? false : true));
      when(() => mockToggleFavorite(any())).thenAnswer((_) async => const Ok(null));
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const LoadDetail(1, MediaKind.movie));
      await Future<void>.delayed(const Duration(milliseconds: 1));
      bloc.add(ToggleFavoriteEvent());
    },
    wait: const Duration(milliseconds: 20),
    expect: () => [isA<DetailLoading>(), isA<DetailLoaded>(), isA<DetailLoaded>()],
    verify: (_) => verify(() => mockToggleFavorite(any())).called(1),
  );

  blocTest<DetailBloc, DetailState>(
    'LoadDetail error -> [Loading, Error]',
    build: () {
      when(() => mockGetMovieDetail(any())).thenAnswer((_) async => const Err(ServerFailure('nope')));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadDetail(9, MediaKind.movie)),
    expect: () => [isA<DetailLoading>(), const DetailError('nope')],
  );
}
