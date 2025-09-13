import 'package:hive_flutter/hive_flutter.dart';

class Prefs {
  static const _box = 'prefsBox';
  static const _kLang = 'language_code';
  static const _kOnboarded = 'onboarded';

  late Box _b;

  Future<void> init() async {
    _b = await Hive.openBox(_box);
  }

  String? get languageCode => _b.get(_kLang);
  bool get isOnboarded => _b.get(_kOnboarded, defaultValue: false) as bool;

  Future<void> setLanguage(String code) async {
    await _b.put(_kLang, code);
    await _b.put(_kOnboarded, true);
  }
}
