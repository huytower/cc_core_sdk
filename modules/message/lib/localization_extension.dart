import 'package:flutter/material.dart';

import 'cc_localization.dart';

/// Extension to easily access localization methods on [BuildContext].
extension LocalizationExtension on BuildContext {
  /// Shortcut for [CcLocalization.translate].
  String tr(String key, {List<String>? args, Map<String, String>? namedArgs}) {
    return CcLocalization.translate(key, args: args, namedArgs: namedArgs);
  }

  /// Shortcut for [CcLocalization.plural].
  String trPlural(String key, num count, {List<String>? args}) {
    return CcLocalization.plural(key, count, args: args);
  }
}
