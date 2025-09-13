import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: Colors.white60, size: 48),
            SizedBox(height: 12),
            Text(context.t('no_data'), style: defaultSubWhiteTextStyle),
          ],
        ),
      ),
    );
  }
}
