import 'package:flutter/material.dart';

import '../../core/config/cc_themes.dart';
import 'theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  @override
  ThemeData getLightTheme() => CcThemes.lightTheme;

  @override
  ThemeData getDarkTheme() => CcThemes.darkTheme;
}
