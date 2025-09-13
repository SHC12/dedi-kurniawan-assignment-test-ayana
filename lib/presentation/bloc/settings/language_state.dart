part of 'language_cubit.dart';

class LanguageState extends Equatable {
  final String code;
  const LanguageState({required this.code});

  @override
  List<Object?> get props => [code];
}
