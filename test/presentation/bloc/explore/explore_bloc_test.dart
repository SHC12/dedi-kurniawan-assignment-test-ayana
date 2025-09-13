import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/explore/explore_bloc.dart';
import 'package:ayana_movies/core/result.dart';
import 'package:ayana_movies/core/failure.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockGetTrendingMedia mockGetTrendingMedia;
  late MockSearchMulti mockSearchMulti;

  setUp(() {
    mockGetTrendingMedia = MockGetTrendingMedia();
    mockSearchMulti = MockSearchMulti();
  });

  blocTest<ExploreBloc, ExploreState>(
    'ExploreStarted -> [Loading, Loaded] when trending ok',
    build: () {
      when(() => mockGetTrendingMedia()).thenAnswer((_) async => const Ok([tMediaMovie, tMediaTv]));
      return ExploreBloc(mockGetTrendingMedia, mockSearchMulti);
    },
    act: (bloc) => bloc.add(const ExploreStarted()),
    expect: () => [isA<ExploreLoading>(), isA<ExploreLoaded>()],
  );

  blocTest<ExploreBloc, ExploreState>(
    'ExploreStarted -> [Loading, Error] when trending fails',
    build: () {
      when(() => mockGetTrendingMedia()).thenAnswer((_) async => const Err(ServerFailure('oops')));
      return ExploreBloc(mockGetTrendingMedia, mockSearchMulti);
    },
    act: (bloc) => bloc.add(const ExploreStarted()),
    expect: () => [isA<ExploreLoading>(), isA<ExploreError>()],
  );

  blocTest<ExploreBloc, ExploreState>(
    'ExploreQueryChanged -> [Searching, Loaded] when search ok (seeded from Loaded)',
    build: () {
      when(() => mockSearchMulti(any())).thenAnswer((_) async => const Ok([tMediaMovie]));
      return ExploreBloc(mockGetTrendingMedia, mockSearchMulti);
    },
    seed: () => ExploreLoaded(
      base: const [tMediaMovie, tMediaTv],
      results: const [tMediaMovie, tMediaTv],
      query: '',
      category: 'All',
      genres: const {},
      year: null,
      country: 'All',
      sortBy: 'Recommended',
    ),
    act: (bloc) => bloc.add(const ExploreQueryChanged('bat')),
    expect: () => [isA<ExploreSearching>(), isA<ExploreLoaded>()],
  );

  blocTest<ExploreBloc, ExploreState>(
    'ExploreQueryChanged -> [Searching, Error] when search fails (seeded from Loaded)',
    build: () {
      when(() => mockSearchMulti(any())).thenAnswer((_) async => const Err(ServerFailure('bad')));
      return ExploreBloc(mockGetTrendingMedia, mockSearchMulti);
    },
    seed: () => ExploreLoaded(
      base: const [tMediaMovie, tMediaTv],
      results: const [tMediaMovie, tMediaTv],
      query: '',
      category: 'All',
      genres: const {},
      year: null,
      country: 'All',
      sortBy: 'Recommended',
    ),
    act: (bloc) => bloc.add(const ExploreQueryChanged('x')),
    expect: () => [isA<ExploreSearching>(), isA<ExploreError>()],
  );
}
