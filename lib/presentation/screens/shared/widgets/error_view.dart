import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/theme/colors.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 42),
            const SizedBox(height: 12),
            Text(message, style: defaultSubWhiteTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onRetry,
              child: Text(context.t('retry'), style: defaultSubWhiteTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
