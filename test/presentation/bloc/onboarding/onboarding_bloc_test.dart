import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ayana_movies/presentation/bloc/onboarding/onboarding_bloc.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockPrefs mockPrefs;

  setUp(() {
    mockPrefs = MockPrefs();
  });

  test('initial state is OnboardingIntro', () {
    expect(OnboardingBloc(mockPrefs).state, isA<OnboardingIntro>());
  });

  blocTest<OnboardingBloc, OnboardingState>(
    'TryNowPressed moves to LanguageChoice, then LanguagePicked updates selection',
    build: () => OnboardingBloc(mockPrefs),
    act: (bloc) async {
      bloc.add(TryNowPressed());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const LanguagePicked('en'));
    },
    expect: () => [isA<OnboardingLanguageChoice>(), const OnboardingLanguageChoice('en')],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'SaveLanguagePressed persists and emits OnboardingSaved',
    build: () => OnboardingBloc(mockPrefs),
    act: (bloc) async {
      bloc.add(TryNowPressed());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const LanguagePicked('id'));
      await Future<void>.delayed(Duration.zero);
      when(() => mockPrefs.setLanguage(any())).thenAnswer((_) async {});
      bloc.add(SaveLanguagePressed());
    },
    expect: () => [isA<OnboardingLanguageChoice>(), const OnboardingLanguageChoice('id'), const OnboardingSaved('id')],
    verify: (_) => verify(() => mockPrefs.setLanguage('id')).called(1),
  );
}
