# Theme Module

A clean, modular theming solution for Flutter applications, following Clean Architecture and SOLID principles.

## 🎨 Features

- Light and dark theme support
- Material 3 theming
- Custom color palette
- Typography system
- Easy theme switching

## 🚀 Usage

1. Add to your app:

```yaml
dependencies:
  theme:
    path: modules/theme

2. Setup provider:

```
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

3. Use in widgets:

```
// Toggle theme
context.read<ThemeProvider>().toggleTheme();

// Use text style
Text('Hello', style: context.textStyle?.bodyLarge);
```

🎨 Customization
Colors
Edit: lib/data/data_source/color/prj_color.dart

Typography
Edit: 
lib/presentation/style/cc_text_style.dart