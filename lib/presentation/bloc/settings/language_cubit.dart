import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const _boxName = 'settings_box';
  static const _keyLang = 'language_code';

  LanguageCubit() : super(const LanguageState(code: 'en')) {
    _load();
  }

  Future<Box> _box() async => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);

  Future<void> _load() async {
    final b = await _box();
    final code = (b.get(_keyLang) as String?) ?? 'en';
    emit(LanguageState(code: code));
  }

  Future<void> setLanguage(String code) async {
    if (state.code == code) return;
    final b = await _box();
    await b.put(_keyLang, code);
    emit(LanguageState(code: code));
  }

  Locale get locale => Locale(state.code);
}
