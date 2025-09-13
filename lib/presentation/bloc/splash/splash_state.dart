part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashGoOnboarding extends SplashState {
  const SplashGoOnboarding();
}

class SplashGoHome extends SplashState {
  final String languageCode;
  const SplashGoHome(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);
  @override
  List<Object?> get props => [message];
}
