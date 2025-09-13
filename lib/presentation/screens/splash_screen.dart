import 'package:ayana_movies/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/typhography.dart';
import '../bloc/locale/locale_cubit.dart';
import '../bloc/splash/splash_bloc.dart';
import '../root_nav_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(AppStarted()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listenWhen: (_, s) => s is SplashGoHome || s is SplashGoOnboarding,
        listener: (context, state) {
          if (state is SplashGoHome) {
            context.read<LocaleCubit>().loadInitial(state.languageCode);

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RootNavScreen()));
          } else if (state is SplashGoOnboarding) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bgSplashColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/ayana.png', width: 60.w)),
                Text('Ayana Movies', style: defaultBigWhiteTextStyle.copyWith(fontSize: 24.sp)),
              ],
            ),
          );
        },
      ),
    );
  }
}
