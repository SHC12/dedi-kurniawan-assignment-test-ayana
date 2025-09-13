import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/presentation/screens/profile/widgets/language_tile.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../bloc/locale/locale_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  String _displayName(String code) {
    switch (code) {
      case 'id':
        return 'Indonesia';
      case 'en':
        return 'English';

      default:
        return code.toUpperCase();
    }
  }

  String _flagOf(String code) {
    switch (code) {
      case 'id':
        return '🇮🇩';
      case 'en':
        return '🇺🇸';
      default:
        return '🇺🇸';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locales = L10n.supportedLocales;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.t('language'), style: defaultBigWhiteTextStyle),
        centerTitle: true,
      ),
      body: BlocBuilder<LocaleCubit, Locale?>(
        builder: (_, current) {
          final selectedCode = (current ?? const Locale('en')).languageCode;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemBuilder: (_, i) {
              final loc = locales[i];
              final code = loc.languageCode;
              final selected = code == selectedCode;

              return LanguageTile(
                flag: _flagOf(code),
                title: _displayName(code),
                selected: selected,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(code);
                  print('$code');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${context.t('selected_language')} ${_displayName(code)}'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: locales.length,
          );
        },
      ),
    );
  }
}
