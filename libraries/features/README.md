# Features Library

A collection of reusable, modular feature packages following CLEAN architecture and SOLID principles.

## 📁 Directory Structure

```
lib/
├── core/                  # Shared code across features
│   ├── constants/        # App-wide constants
│   ├── di/               # Dependency injection setup
│   └── utils/            # Shared utilities
│
└── {feature_name}/        # Feature modules (lowercase with underscores)
    ├── data/
    │   ├── datasources/  # Data sources (API, local storage, etc.)
    │   └── repositories/ # Repository implementations
    │
    ├── di/               # Feature-specific DI
    │   └── {feature_name}_module.dart
    │
    ├── domain/
    │   ├── entities/     # Business objects
    │   ├── repositories/ # Repository contracts
    │   └── usecases/    # Business logic
    │
    └── presentation/
        ├── pages/       # Feature screens
        └── widgets/     # Reusable UI components
```

## 🚀 Getting Started

### Adding to Your Project

Add this to your app's `pubspec.yaml`:

```yaml
dependencies:
  features:
    path: libraries/features
```

### Creating a New Feature

1. **Use the template**: Copy an existing feature (like `counter`) as a starting point
2. **Rame files and classes**: Update all references to match your feature name
3. **Implement layers**:
    - `data/`: Data sources and repositories
    - `domain/`: Business logic and entities
    - `presentation/`: UI components
4. **Set up DI**: Update the feature module in `di/`
5. **Export your feature**: Add exports to `lib/features.dart`

## 🏗️ Feature Template

For detailed implementation examples, see the [Feature Template](../../docs/feature_template.md) documentation.

## 🧪 Testing

Each feature should include tests for:

- Data layer (repositories, data sources)
- Domain layer (use cases, entities)
- Presentation layer (widgets, controllers)

Example test structure:

```
test/
  ├── {feature_name}_test/
  │   ├── data/
  │   ├── domain/
  │   └── presentation/
  └── test_helpers/     # Test utilities and mocks
```

## 📦 Dependencies

Core dependencies used across features:

- `get_it`: Service locator
- `injectable`: Code generation for dependency injection
- `equatable`: Value equality
- `dio`: HTTP client
- `shared_preferences`: Local storage

## 🔄 State Management

Features should use the project's standard state management solution (e.g., GetX, Bloc, or Provider) consistently.

## 📝 Code Generation

Run build_runner after making changes to DI:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🔗 Related Libraries

- `cc_sdk_ui`: UI component library used across apps and features. See [libraries/cc_sdk_ui/README.md](libraries/cc_sdk_ui/README.md) for usage and examples.
- `cc_sdk`: Core SDK utilities and shared services used by features. See [libraries/cc_sdk/README.md](libraries/cc_sdk/README.md).