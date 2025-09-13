import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/search/search_bloc.dart';
import 'package:ayana_movies/core/result.dart';
import 'package:ayana_movies/core/failure.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
  });

  blocTest<SearchBloc, SearchState>(
    'emits [Idle] when DoSearch with empty query',
    build: () => SearchBloc(mockSearchMovies),
    act: (bloc) => bloc.add(const DoSearch('   ')),
    expect: () => [isA<SearchIdle>()],
    verify: (_) => verifyNever(() => mockSearchMovies(any(), forceRefresh: any(named: 'forceRefresh'))),
  );

  blocTest<SearchBloc, SearchState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(
        () => mockSearchMovies(any(), forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => const Ok([tMovie]));
      return SearchBloc(mockSearchMovies);
    },
    act: (bloc) => bloc.add(const DoSearch('batman', forceRefresh: true)),
    expect: () => [
      isA<SearchLoading>(),
      const SearchLoaded([tMovie]),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(
        () => mockSearchMovies(any(), forceRefresh: any(named: 'forceRefresh')),
      ).thenAnswer((_) async => const Err(NetworkFailure('no net')));
      return SearchBloc(mockSearchMovies);
    },
    act: (bloc) => bloc.add(const DoSearch('superman')),
    expect: () => [isA<SearchLoading>(), const SearchError('no net')],
  );
}
