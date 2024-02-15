import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../src/app.dart';

final context = navigatorKey.currentContext!;

class L10n {
  static final all = [
    const Locale("en"),
    const Locale("ar"),
  ];
}

class Strings {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// ## Use it only for translation outside the UI widgets like:
  /// * APIs errors
  /// * General Functions, etc...
  /// ### It is useful because the `context` is not required.
  static AppLocalizations get get {
    return AppLocalizations.of(context)!;
  }
}
