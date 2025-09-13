import 'package:ayana_movies/core/l10n.dart';
import 'package:ayana_movies/core/theme/typhography.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.t('no_data'), style: defaultDimTextStyle));
  }
}
