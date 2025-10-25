import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../data/data_source/color/prj_color.dart';
import '../../presentation/style/cc_text_style.dart';

/// Creates a color scheme based on the provided brightness
ColorScheme createColorScheme(Brightness brightness) {
  return ColorScheme(
    primary: PrjColors.primary,
    secondary: PrjColors.secondary,
    surface: PrjColors.surface,
    background: PrjColors.background,
    error: PrjColors.error,
    onPrimary: PrjColors.onPrimary,
    onSecondary: PrjColors.onSecondary,
    onSurface: PrjColors.onSurface,
    onBackground: PrjColors.onBackground,
    onError: PrjColors.onError,
    brightness: brightness,
  );
}

/// Returns the list of supported localization delegates
List<LocalizationsDelegate> getLocalizationDelegates() {
  return const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

/// Returns the list of supported locales
List<Locale> getSupportedLocales() {
  return const [
    Locale('en', ''), // English, no country code
  ];
}

/// Creates a light utils configuration
ThemeData createLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: createColorScheme(Brightness.light),
    extensions: <ThemeExtension<dynamic>>[
      CcTextStyle.light(),
    ],
  );
}

/// Creates a dark utils configuration
ThemeData createDarkTheme() {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: createColorScheme(Brightness.dark),
    extensions: <ThemeExtension<dynamic>>[
      CcTextStyle.dark(),
    ],
  );
}
