import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

class L10n {
  final Locale locale;
  late Map<String, String> _localized;

  L10n(this.locale);
  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();
  static const supportedLocales = [Locale('en'), Locale('id')];

  static L10n of(BuildContext context) => Localizations.of<L10n>(context, L10n)!;

  Future<bool> load() async {
    final data = await rootBundle.loadString('assets/i18n/${locale.languageCode}.arb');
    final map = json.decode(data) as Map<String, dynamic>;
    _localized = map.map((k, v) => MapEntry(k, v.toString()));
    return true;
  }

  String t(String key) => _localized[key] ?? key;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);
  @override
  Future<L10n> load(Locale locale) async {
    final l = L10n(locale);
    await l.load();
    return l;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<L10n> old) => false;
}
