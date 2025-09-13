import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di.dart';
import '../../../core/theme/colors.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../bloc/onboarding/onboarding_bloc.dart';
import '../../root_nav_screen.dart';
import '../../../core/theme/typhography.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B0E14);
    const accent1 = Color(0xFF4F8BFF);
    const accent2 = Color(0xFF00D4FF);
    return BlocProvider(
      create: (_) => OnboardingBloc(sl<Prefs>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: LayoutBuilder(
              builder: (context, c) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/bg_onboarding.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.45), bg, bg],
                            stops: const [0.0, 0.45, 0.72, 1.0],
                          ),
                        ),
                      ),
                    ),

                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: BlocConsumer<OnboardingBloc, OnboardingState>(
                            listenWhen: (_, s) => s is OnboardingSaved,
                            listener: (context, state) {
                              if (state is OnboardingSaved) {
                                context.read<LocaleCubit>().setLocale(state.code);

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const RootNavScreen()),
                                  (route) => false,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is OnboardingLanguageChoice) {
                                return _LanguageChoiceContent(
                                  selected: state.selectedCode,
                                  onSelect: (code) => context.read<OnboardingBloc>().add(LanguagePicked(code)),
                                  onSave: state.selectedCode == null
                                      ? null
                                      : () => context.read<OnboardingBloc>().add(SaveLanguagePressed()),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.t('welcome'),
                                    textAlign: TextAlign.center,
                                    style: defaultBigWhiteTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    context.t('welcome_desc'),
                                    textAlign: TextAlign.center,
                                    style: defaultSubDimTextStyle,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [accent2, accent1],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accent2.withOpacity(0.25),
                                            blurRadius: 24,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                        ),
                                        onPressed: () => context.read<OnboardingBloc>().add(TryNowPressed()),
                                        child: Text(context.t('try_now'), style: defaultWhiteTextStyle),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _LanguageChoiceContent extends StatelessWidget {
  final String? selected;
  final void Function(String code) onSelect;
  final VoidCallback? onSave;
  const _LanguageChoiceContent({required this.selected, required this.onSelect, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangTile(
          title: 'English',
          subtitle: 'Use English interface',
          selected: selected == 'en',
          onTap: () => onSelect('en'),
        ),
        const SizedBox(height: 12),
        _LangTile(
          title: 'Bahasa Indonesia',
          subtitle: 'Gunakan antarmuka Bahasa Indonesia',
          selected: selected == 'id',
          onTap: () => onSelect('id'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onSave,

            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Save Language', style: defaultWhiteTextStyle),
          ),
        ),
      ],
    );
  }
}

class _LangTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _LangTile({required this.title, required this.subtitle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.white : Colors.white24, width: 2),
          color: selected ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.04),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
