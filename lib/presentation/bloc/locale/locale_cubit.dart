import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  void loadInitial(String? code) {
    if (code == null) return;
    emit(Locale(code));
  }

  void setLocale(String code) {
    emit(Locale(code));
  }
}
