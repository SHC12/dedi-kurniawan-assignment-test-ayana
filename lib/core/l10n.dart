import 'package:flutter/material.dart';

import '../presentation/l10n/l10n.dart';

extension L10nContextX on BuildContext {
  L10n get l10n => L10n.of(this);
  String t(String key) => L10n.of(this).t(key);
}
