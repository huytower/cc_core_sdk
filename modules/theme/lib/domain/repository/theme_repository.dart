// domain/repositories/theme_repository.dart
import 'package:flutter/material.dart';

abstract class ThemeRepository {
  ThemeData getLightTheme();

  ThemeData getDarkTheme();
}
