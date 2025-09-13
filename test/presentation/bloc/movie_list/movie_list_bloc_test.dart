import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ayana_movies/core/result.dart';
import 'package:ayana_movies/core/failure.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockGetPopularMovies mockGetPopular;

  setUp(() {
    mockGetPopular = MockGetPopularMovies();
  });

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Loaded] when LoadPopular succeeds',
    build: () {
      when(() => mockGetPopular(forceRefresh: any(named: 'forceRefresh'))).thenAnswer((_) async => const Ok([tMovie]));
      return MovieListBloc(mockGetPopular);
    },
    act: (bloc) => bloc.add(const LoadPopular(forceRefresh: true)),
    expect: () => [
      isA<MovieListLoading>(),
      const MovieListLoaded([tMovie]),
    ],
    verify: (_) => verify(() => mockGetPopular(forceRefresh: true)).called(1),
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Error] when LoadPopular fails',
    build: () {
      when(
        () => mockGetPopular(forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => const Err(ServerFailure('boom')));
      return MovieListBloc(mockGetPopular);
    },
    act: (bloc) => bloc.add(const LoadPopular(forceRefresh: false)),
    expect: () => [isA<MovieListLoading>(), const MovieListError('boom')],
    verify: (_) => verify(() => mockGetPopular(forceRefresh: false)).called(1),
  );
}
