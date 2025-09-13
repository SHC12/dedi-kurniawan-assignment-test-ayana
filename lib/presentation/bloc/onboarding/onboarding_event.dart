part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class TryNowPressed extends OnboardingEvent {}

class LanguagePicked extends OnboardingEvent {
  final String code;
  const LanguagePicked(this.code);
  @override
  List<Object?> get props => [code];
}

class SaveLanguagePressed extends OnboardingEvent {}
