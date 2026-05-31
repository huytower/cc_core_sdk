# AI Context - Flutter Get Starter Template

A modular Flutter starter built around **Clean Architecture** and **SOLID principles**, with reusable packages for core SDK, UI, and feature modules.

**Project Path:** `C:\Users\Admin\repository\flutter-get-starter-template`

## AI Guidelines & Strategic Guardrails

1. **State-Management Agnostic Design (CRITICAL)**: All components in `cc_sdk`, `cc_sdk_ui`, `cc_mixin`, and `features` MUST be state-management agnostic. Components must work with GetX or Bloc without being tied to a specific one.

   **Requirements:**
   - Core SDK libraries must not depend on specific state management libraries
   - Use mixins to provide reusable functionality across GetX and Bloc
   - Use required/optional methods for implementation details with default implementations
   - Use dependency injection to inject implementations rather than hard-coding state management

2. **Architecture Respect**: Maintain existing patterns and architecture. Propose refactors only when requested or essential for new feature stability.

3. **Precise Scope**: Limit modifications strictly to files directly required for the current task.

4. **Final-State Delivery**: Provide final, production-ready implementation immediately. Skip intermediate wrappers or temporary helper files.

5. **SDK-First Component Reuse**: Prioritize components from `libraries/cc_sdk_ui`.

6. **Clean Bootstrap Integrity**: Preserve `main.dart` as lean, service-only entry point (Env -> DI -> Hive -> Localization).

7. **Collaborative Evolution**: For structural changes (file movements, return type updates, DI shifts), present clear plan and proceed after developer confirmation.

8. **Evidence-Based Implementation**: Use read_file and analyze_file to verify current structure before proposing changes.

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
│   └── theme/                   # Theming system
├── libraries/                    # Reusable libraries
│   ├── cc_sdk/                  # Core SDK (network, device, failures)
│   ├── cc_sdk_ui/               # UI component library
│   ├── cc_mixin/                # Reusable mixins
│   └── features/                # Modular feature packages
└── docs/                        # Documentation
```

## Dependency Injection (DI) Convention

| Category | Convention | Example |
| :--- | :--- | :--- |
| **File Location** | Always `lib/core/di/di.dart` | `data/lib/core/di/di.dart` |
| **Method Name** | Always `initMicroPackage()` | `void initMicroPackage() {}` |
| **Locator Name** | Always `getIt` | `final getIt = GetIt.instance;` |
| **Generated File**| Always `di.module.dart` | `import 'di.module.dart';` |

### Module Implementation
Every library and module must implement DI using Micro-Package pattern with `@InjectableInit.microPackage()` annotation on `initMicroPackage()` method.

### Main App Integration
The main app consolidates all modules in `lib/core/di/di.dart` using `@InjectableInit` with `externalPackageModulesBefore`.

## Core Libraries

### libraries/cc_sdk (Core SDK)
**Purpose:** Essential functionality and utilities

**State-Management Requirements:**
- Must NOT depend on specific state management libraries
- All components must be state-management agnostic
- Use mixins and interfaces for reusable functionality

**Key Components:**
- Network utilities (CURL, interceptors, connectivity)
- Feature flags and environment toggles
- Device information
- Common extensions and helpers
- Serialization (GSON-style)
- Error handling with Failure types
- Clean Architecture implementation (Domain/Data/Core layers)

**DI File:** `libraries/cc_sdk/lib/core/di/di.dart`

### libraries/cc_sdk_ui (UI Components)
**Purpose:** Reusable, customizable UI components

**State-Management Requirements:**
- Must NOT depend on specific state management libraries
- All widgets must be state-management agnostic
- Use value parameters and callbacks rather than coupled state management

**Key Components:**
- Buttons (CcCloseBtn, CcDebounce, CcBaseBtn)
- Dialogs and bottom sheets
- Form elements (text fields, validators)
- Loaders & indicators (spinners, skeletons)
- Layout components (containers, cards, dividers)
- Text & typography widgets
- Animations (fade, scale, transitions)
- Navigation (CcCurvedNavigationBar - state-management agnostic)

**Theme Tokens:**
- `CcBaseColors`: Color palette (brand, neutral, semantic)
- `CcTypographyParams`: Typography system (sizes, weights)

**DI File:** No DI file (stateless UI library)

### libraries/cc_mixin (Reusable Mixins)
**Purpose:** Reusable mixins for common functionality

**State-Management Requirements:**
- All mixins must be state-management agnostic
- Provide reusable functionality without imposing specific state management patterns
- Use required methods for implementation details, with default implementations for common cases

**Key Mixins:**
- **CcCurvedNavigationMixin**: Provides curved navigation bar functionality (Home, Notification, Profile items)
  - Required: `currentIndex` getter and `setIndex` method
  - Optional: Navigation items, colors, dimensions, style presets
  - Works with any state management approach

**DI File:** No DI file (mixin library)

### libraries/features (Feature Modules)
**Purpose:** Standalone, shareable feature modules

**State-Management Requirements:**
- Feature modules should be designed to work with different state management approaches
- Provide clear separation between feature logic (state-management agnostic) and presentation (state-management specific)
- Use dependency injection to allow consuming applications to choose their preferred state management

**Structure per feature:**
```
{feature_name}/
├── data/                        # State-management agnostic
│   ├── datasources/             # API, local storage
│   └── repositories/            # Repository implementations
├── domain/                      # State-management agnostic
│   ├── entities/                # Business objects
│   ├── repositories/            # Repository contracts
│   └── usecases/               # Business logic
├── presentation/                # State-management specific
│   ├── bloc/                    # Bloc implementation (optional)
│   ├── getx/                    # GetX implementation (optional)
│   ├── pages/                   # Feature screens
│   └── widgets/                 # Reusable UI components (agnostic)
└── core/di/di.dart             # Standardized DI entry
```

**DI File:** `libraries/features/lib/core/di/di.dart`

## App Modules

### modules/app_config
**Purpose:** Application configuration and dependency management

**State-Management Requirements:**
- Must be state-management agnostic
- Configuration, DI, and storage should not depend on specific state management libraries

**Features:**
- Version and build information
- Environment-specific settings (.env files)
- Centralized dependency registration (Micro-Package)
- Hive-based local storage with type adapters

**DI File:** `modules/app_config/lib/core/di/di.dart`

### modules/data
**Purpose:** Data layer configuration and implementation

**State-Management Requirements:**
- Must be state-management agnostic
- Data sources, repositories, and parsing should not depend on specific state management
- Provide data through standard interfaces (Result<T, Failure>) that work with any state management

**Features:**
- Remote server configuration (Retrofit)
- Server response handling
- JSON parsing
- Local database (Floor)
- Repository pattern

**DI File:** `modules/data/lib/core/di/di.dart`

### modules/theme
**Purpose:** Theming system with Clean Architecture

**State-Management Requirements:**
- Must be state-management agnostic
- Theme changes should be accessible through standard interfaces (not tied to specific state management)

### modules/message
**Purpose:** Internationalization (i18n) and localization

**State-Management Requirements:**
- Must be state-management agnostic
- Translation and localization should not depend on specific state management libraries

## Key Technologies

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation for DI (v3.0+)
- **Micro-Packages**: For modular DI discovery
- **Annotations**: @injectable, @module, @preResolve, @named, @singleton, @lazySingleton, @InjectableInit.microPackage()

### State Management
- **Multi-Support**: The project supports GetX and Bloc state management approaches
- **State-Management Agnostic Core**: Core libraries (cc_sdk, cc_sdk_ui, cc_mixin, features) must be state-management agnostic
- **Flexibility**: Choose the state management approach that works best for your feature or team
- **No Lock-in**: Core components are not locked to any specific state management library

**State-Management Usage:**
- Use GetX or Bloc in the `lib/presentation` layer for specific features
- Keep core libraries (cc_sdk, cc_sdk_ui, cc_mixin, features) state-management agnostic
- Provide abstract interfaces in features that can be implemented with GetX or Bloc
- Use dependency injection to inject state management implementations

## CI/CD Configuration

### Melos 7.x.x Workspace
- **Workspace:** Melos 7.x.x pub workspaces (no melos.yaml, uses pubspec.yaml workspace config)
- **Global Melos activation:** Required for script compatibility in CI
- **Generated files:** Selected modules commit generated files for analysis
- **Lint rules:** `prefer_relative_imports` disabled for generated files

## Development Workflow

```bash
melos bootstrap              # Bootstrap the workspace
melos run gen                # Generate code
melos run analyze            # Run analysis
melos run test               # Run tests
melos clean                  # Clean and rebuild
```

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
