import 'package:ayana_movies/core/prefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final Prefs prefs;
  OnboardingBloc(this.prefs) : super(const OnboardingIntro()) {
    on<TryNowPressed>((event, emit) {
      emit(const OnboardingLanguageChoice(null));
    });

    on<LanguagePicked>((event, emit) {
      if (state is OnboardingLanguageChoice) {
        emit(OnboardingLanguageChoice(event.code));
      }
    });

    on<SaveLanguagePressed>((event, emit) async {
      final cur = state;
      if (cur is OnboardingLanguageChoice && cur.selectedCode != null) {
        await prefs.setLanguage(cur.selectedCode!);
        emit(OnboardingSaved(cur.selectedCode!));
      }
    });
  }
}
