import 'package:ayana_movies/core/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di.dart';
import '../bloc/locale/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Language'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () async {
                  localeCubit.setLocale('en');
                  await sl<Prefs>().setLanguage('en');
                },
                child: const Text('English'),
              ),
              OutlinedButton(
                onPressed: () async {
                  localeCubit.setLocale('id');
                  await sl<Prefs>().setLanguage('id');
                },
                child: const Text('Indonesia'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
