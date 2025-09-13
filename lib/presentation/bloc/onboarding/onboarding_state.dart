part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingIntro extends OnboardingState {
  const OnboardingIntro();
}

class OnboardingLanguageChoice extends OnboardingState {
  final String? selectedCode;
  const OnboardingLanguageChoice(this.selectedCode);
  @override
  List<Object?> get props => [selectedCode];
}

class OnboardingSaved extends OnboardingState {
  final String code;
  const OnboardingSaved(this.code);
  @override
  List<Object?> get props => [code];
}
