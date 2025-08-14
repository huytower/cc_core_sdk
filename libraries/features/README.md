# Features Library

A collection of reusable feature modules for the application.

## Structure

```
lib/
├── src/
│   ├── di/               # Dependency injection configuration
│   ├── features/         # Individual feature modules
│   │   ├── feature1/     # Example feature 1
│   │   └── feature2/     # Example feature 2
│   └── features.dart     # Exports all features
└── features.dart         # Library entry point
```

## Adding a New Feature

1. Create a new directory under `lib/src/features/`
2. Follow the structure:
   ```
   feature_name/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       └── pages/
   ```

3. Export your feature in `lib/src/features.dart`

## Usage

Add to your project's `pubspec.yaml`:

```yaml
dependencies:
  features:
    path: libraries/features
```

## Dependencies

- flutter_bloc: ^8.1.3
- get_it: ^7.6.4
- injectable: ^2.1.0
- equatable: ^2.0.5
