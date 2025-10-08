# Reusable Module

This module contains reusable widgets, utilities, and extensions that can be used across the application.

## Project Structure

```
lib/
├── extensions/         # Dart extensions
├── global/            # Global widget utilities
├── pages/             # Page-level widgets
│   ├── error/         # Error page components
│   └── loading/       # Loading page components
├── utils/             # Utility classes and helper functions
└── widgets/           # Reusable UI components
    ├── avatars/       # Avatar components
    ├── buttons/       # Button components
    ├── cards/         # Card components
    ├── spinners/      # Loading indicators
    ├── switches/      # Switch components
    └── toasts/        # Toast notifications
```

## Usage

### Widgets

Import and use widgets directly in your code:

```dart
import 'package:reusable/widgets/buttons/your_button.dart';
import 'package:reusable/widgets/cards/your_card.dart';
```

### Extensions

Import and use extensions like this:

```dart
import 'package:reusable/extensions/cc_extension.dart';

// Example usage
String? nullableString;
String safeString = nullableString.ctmConvertNull();
```

### Utils

Import and use utility classes:

```dart
import 'package:reusable/utils/logger_helper.dart';

// Example usage
LoggerHelper.printCustom('Debug message');
```

## Adding New Components

1. **Widgets**: Add new widgets in the appropriate subdirectory under `widgets/`
2. **Pages**: Add page-level widgets under `pages/`
3. **Utils**: Add utility classes under `utils/`
4. **Extensions**: Add new extensions under `extensions/`

## Naming Conventions

- Widget files: Use lowercase with underscores (e.g., `my_widget.dart`)
- Widget classes: Use PascalCase (e.g., `class MyWidget`)
- Utility files: Use snake_case with `_helper` or `_util` suffix (e.g., `logger_helper.dart`)
- Extension files: Use descriptive names with `_extension` suffix (e.g., `string_extension.dart`)