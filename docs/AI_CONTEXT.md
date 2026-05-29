# AI Context - Flutter Get Starter Template

## AI Context - Flutter Get Starter Template

A modular Flutter starter built around **Clean Architecture** and **SOLID principles**, with reusable packages for core SDK, UI, and feature modules.

**Project Path:** `C:\Users\Admin\repository\flutter-get-starter-template`

## AI Guidelines & Strategic Guardrails (POSITIVE)

To ensure high-quality, predictable development and maintain project integrity, the AI must adhere to these standards:

1.  **Architecture Respect**: Maintain the existing patterns and architecture. Propose refactors only when requested or when essential for a new feature's stability.
2.  **Precise Scope**: Limit modifications strictly to files directly required for the current task. Keep surrounding code stable.
3.  **Final-State Delivery**: Provide the final, production-ready implementation immediately. Skip intermediate wrappers or temporary helper files.
4.  **SDK-First Component Reuse**: Prioritize components from `libraries/cc_sdk_ui`. Use existing buttons, error pages, and layouts to ensure design consistency.
5.  **Clean Bootstrap Integrity**: Preserve `main.dart` as a lean, service-only entry point (Env -> DI -> Hive -> Localization). Delegate UI construction to `AppRunner.dart` or Feature modules.
6.  **Collaborative Evolution**: For structural changes (file movements, return type updates, DI shifts), present a clear plan and proceed only after developer confirmation.
7.  **Evidence-Based Implementation**: Use `read_file` and `analyze_file` to verify the current structure before proposing any changes.

## Future Development Goals & Strategy

### Short-Term Feature Goals
- **Standardized Failure Adoption**: Transition all features (like Dashboard) to use the `Result<T, Failure>` pattern for robust error handling.
- **Enhanced Data Parsing**: Integrate `CcResBodyModel` across all Remote DataSources for consistent envelope peeling.
- **Persistence Optimization**: Migrate remaining in-memory caches to `Hive` storage within the `modules/app_config` framework.

### Long-Term Strategic Vision
- **Module Decoupling**: Progressively isolate feature modules to ensure they can be tested and developed independently.
- **DI Optimization**: Refine the Micro-Package DI strategy to ensure faster build times and clearer dependency graphs.
- **UI Component Maturity**: Expand `cc_sdk_ui` to include all common app patterns, reducing the need for feature-specific widgets.

## Recommended Onboarding Path

- Start with `README.md` and this `AI_CONTEXT.md` for architecture intent.
- Read `docs/onboarding.md` for a step-by-step developer guide.
- Open `lib/main.dart` to understand how the app boots, loads dependencies, and wraps the root widget.
- Check `lib/core/di/di.dart` for the global DI assembly and module registration.
- Review `libraries/features/lib/export_features.dart` to find reusable feature exports.
- Use `modules/` for app-specific domain and data logic.

## Project Overview

Flutter starter template following **Clean Architecture** and **SOLID principles** with modular structure.

**Project Path:** `C:\Users\Admin\repository\flutter-get-starter-template`

## Architecture Principles

### Clean Architecture
- **Domain Layer**: Business logic, use cases, entities, repository interfaces
- **Data Layer**: Data sources (remote/local), repository implementations, entities
- **Presentation Layer**: UI components, pages, widgets

### SOLID Principles
- **Single Responsibility**: Each class/module has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable for base types
- **Interface Segregation**: Clients shouldn't depend on unused interfaces
- **Dependency Inversion**: Depend on abstractions, not concretions

## Project Structure

```
flutter-get-starter-template/
├── lib/                          # Main app code
│   ├── core/                     # Core app logic
│   │   └── di/                  # Centralized DI entry point
│   ├── data/                     # Data layer
│   ├── presentation/             # UI layer
│   └── main*.dart               # Entry points (prod, uat, logging, free)
├── modules/                      # App-specific modules
│   ├── app_config/              # Configuration, DI, storage
│   ├── data/                    # Data sources, repositories, entities
│   ├── message/                 # i18n/localization
  └── theme/                   # Theming system
├── libraries/                    # Reusable libraries
│   ├── cc_sdk/                  # Core SDK (network, device, failures)
│   ├── cc_sdk_ui/               # UI component library
│   └── features/                # Modular feature packages
└── docs/                        # Documentation
```

## Dependency Injection (DI) Convention

To ensure consistency and simplicity across all modules, follow the **Predictable Pattern**.

| Category | Convention | Location / Example |
| :--- | :--- | :--- |
| **File Location** | Always `lib/core/di/di.dart` | `data/lib/core/di/di.dart` |
| **Method Name** | Always `initMicroPackage()` | `void initMicroPackage() {}` |
| **Locator Name** | Always `getIt` | `final getIt = GetIt.instance;` |
| **Generated File**| Always `di.module.dart` | `import 'di.module.dart';` |

### Module Implementation
Every library and module must implement DI using the **Micro-Package** pattern:
```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit.microPackage()
void initMicroPackage() {}
```

### Main App Integration
The main app consolidates all modules in `lib/core/di/di.dart`:
- Uses `@InjectableInit` with `externalPackageModulesBefore`.
- Includes all generated `MicroPackageModule` classes from dependencies.
- Use `ignoreUnregisteredTypes` for common third-party types (e.g., `SharedPreferences`, `Dio`).

## Core Libraries

### libraries/cc_sdk (Core SDK)
**Purpose:** Essential functionality and utilities

**Key Components:**
- Network utilities (CURL, interceptors, connectivity)
- Feature flags and environment toggles
- Device information
- Common extensions and helpers
- Serialization (GSON-style)
- Error handling with Failure types
- Clean Architecture implementation

**Architecture Flow:**
1. **Domain Layer**: UseCases (business logic) + Repository Interfaces (contracts)
2. **Data Layer**: Repository Implementations (managers) + DataSources (laborers)
3. **Core Layer**: Standardized failures (CcNetworkFailure, CcServerFailure, CcAppConfigFailure)

**DI File:** `libraries/cc_sdk/lib/core/di/di.dart`

### libraries/cc_sdk_ui (UI Components)
**Purpose:** Reusable, customizable UI components

**Components:**
- Buttons: CcCloseBtn, CcDebounce, CcBaseBtn
- Dialogs and bottom sheets
- Form elements (text fields, validators)
- Loaders & indicators (spinners, skeletons)
- Layout components (containers, cards, dividers)
- Text & typography widgets
- Animations (fade, scale, transitions)

**Theme Tokens:**
- `CcBaseColors`: Color palette (brand, neutral, semantic)
- `CcTypographyParams`: Typography system (sizes, weights)

### libraries/features (Feature Modules)
**Purpose:** Modular, reusable feature packages

**Structure per feature:**
```
{feature_name}/
├── data/
│   ├── datasources/          # API, local storage
│   └── repositories/         # Repository implementations
├── domain/
│   ├── entities/             # Business objects
│   ├── repositories/         # Repository contracts
│   └── usecases/            # Business logic
├── presentation/
│   ├── pages/               # Feature screens
│   └── widgets/             # Reusable UI components
└── core/di/di.dart          # Standardized DI entry
```

## App Modules

### modules/app_config
**Purpose:** Application configuration and dependency management

**Features:**
- Version and build information
- Environment-specific settings (.env files)
- Centralized dependency registration (Micro-Package)
- Hive-based local storage with type adapters

**DI File:** `modules/app_config/lib/core/di/di.dart`

### modules/data
**Purpose:** Data layer configuration and implementation

**Features:**
- Remote server configuration (Retrofit)
- Server response handling
- JSON parsing
- Local database (Floor)
- Repository pattern

**DI File:** `modules/data/lib/core/di/di.dart`

### modules/theme
**Purpose:** Theming system with Clean Architecture

### modules/message
**Purpose:** Internationalization (i18n) and localization

## Key Technologies

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation for DI (v3.0+)
- **Micro-Packages**: For modular DI discovery
- **Annotations**: @injectable, @module, @preResolve, @named, @singleton, @lazySingleton, @InjectableInit.microPackage()

### State Management
- **GetX**: State management, routing, dependency injection
- **Bloc**: State management with streams
- **Provider**: State management (alternative)

## Coding Standards

### Clean Architecture Rules
- **Domain layer** must not depend on Data or Presentation layers
- **Data layer** depends on Domain layer (repository interfaces)
- **Presentation layer** depends on Domain layer (use cases)
- Use dependency injection to invert dependencies

### Naming Conventions
- **DI Locator**: Always `getIt`
- **DI Entry**: `lib/core/di/di.dart`
- Classes: PascalCase (e.g., `UserProfileRepository`)
- Files: snake_case (e.g., `user_profile_repository.dart`)

### Linter & Code Style
- **Prefer Relative Imports**: Use relative paths for imports within the same package to maintain modularity and avoid brittle package-name dependencies.
- **Const Constructors**: Use `const` for widgets and objects whenever possible to optimize performance and widget tree rebuilding.
- **Clean Imports**:
    - Remove unnecessary or unused imports.
    - Avoid redundant imports (e.g., don't import a file if all its elements are already provided by another broader export or import).
    - Group imports: Flutter/Dart first, then third-party packages, then project-specific modules.
    - Follow naming conventions: Follow consistent naming conventions for classes, files, and variables to improve code readability and maintainability.
    - Use type annotations: Use type annotations to improve code clarity and help the Dart analyzer provide better code suggestions and error messages.
- **Analyze code with Dart analysis tools**: Use Dart analysis tools like dartanalyzer or dartfmt to catch potential issues and enforce coding standards.
- **Review generated code**: Review the generated code to ensure it aligns with the project's requirements and coding standards.


## Adding New Code

### DI Implementation Steps
1. Create/Update `lib/core/di/di.dart` in your module.
2. Annotate with `@InjectableInit.microPackage()`.
3. Add injectable annotations to your classes.
4. Run `build_runner` in the module.
5. Reference the generated `MicroPackageModule` in the main app's `di.dart`.
6. Run `build_runner` in the main app.
