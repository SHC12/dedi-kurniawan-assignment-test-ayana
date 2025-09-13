import 'dart:async';
import 'package:ayana_movies/core/prefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di.dart';
import '../../../core/hive_helper.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStarted>(_onInit);
    on<RetryInit>(_onInit);
  }

  Future<void> _onInit(SplashEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    try {
      await Future.wait([HiveHelper.init(), initDI(), Future.delayed(const Duration(seconds: 2))]);
      final prefs = sl<Prefs>();
      await prefs.init();

      final code = prefs.languageCode;
      final onboarded = prefs.isOnboarded && code != null;

      if (onboarded) {
        if (!emit.isDone) emit(SplashGoHome(code));
      } else {
        if (!emit.isDone) emit(const SplashGoOnboarding());
      }
    } catch (e) {
      if (!emit.isDone) emit(SplashError(e.toString()));
    }
  }
}
