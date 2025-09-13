import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/tv/tv_bloc.dart';
import 'package:ayana_movies/core/result.dart';
import 'package:ayana_movies/core/failure.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
  });

  blocTest<TvBloc, TvState>(
    'emits [Loading, Loaded] when LoadPopularTv succeeds',
    build: () {
      when(() => mockGetPopularTv()).thenAnswer((_) async => const Ok([tTv]));
      return TvBloc(mockGetPopularTv);
    },
    act: (bloc) => bloc.add(const LoadPopularTv()),
    expect: () => [
      isA<TvLoading>(),
      const TvLoaded([tTv]),
    ],
    verify: (_) => verify(() => mockGetPopularTv()).called(1),
  );

  blocTest<TvBloc, TvState>(
    'emits [Loading, Error] when LoadPopularTv fails',
    build: () {
      when(() => mockGetPopularTv()).thenAnswer((_) async => const Err(ServerFailure('fail tv')));
      return TvBloc(mockGetPopularTv);
    },
    act: (bloc) => bloc.add(const LoadPopularTv()),
    expect: () => [isA<TvLoading>(), const TvError('fail tv')],
  );
}
