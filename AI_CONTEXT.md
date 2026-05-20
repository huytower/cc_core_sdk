# AI Context - Flutter Get Starter Template

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
│   ├── data/                     # Data layer
│   ├── presentation/             # UI layer
│   └── main*.dart               # Entry points (prod, uat, logging, free)
├── modules/                      # App-specific modules
│   ├── app_config/              # Configuration, DI, storage
│   ├── data/                    # Data sources, repositories, entities
│   ├── message/                 # i18n/localization
│   ├── theme/                   # Theming system
│   └── widget/                  # App-specific widgets
├── libraries/                    # Reusable libraries
│   ├── cc_sdk/                  # Core SDK (network, device, failures)
│   ├── cc_sdk_ui/               # UI component library
│   └── features/                # Modular feature packages
└── docs/                        # Documentation
```

## Core Libraries

### libraries/cc_sdk (Core SDK)
**Purpose:** Essential functionality and utilities

**Key Components:**
- Network utilities (CURL, interceptors, connectivity)
- Device information
- Common extensions and helpers
- Serialization (GSON-style)
- Error handling with Failure types
- Clean Architecture implementation

**Architecture Flow:**
1. **Domain Layer**: UseCases (business logic) + Repository Interfaces (contracts)
2. **Data Layer**: Repository Implementations (managers) + DataSources (laborers)
3. **Core Layer**: Standardized failures (NetworkFailure, ServerFailure, AppConfigFailure)

**Dependencies:** connectivity_plus, dio, device_info_plus, crypto, equatable, google_fonts, intl, multiple_result, package_info_plus

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
- `BaseColors`: Color palette (brand, neutral, semantic)
- `CcTypographyParams`: Typography system (sizes, weights)

**Dependencies:** cc_sdk, flutter_svg, google_fonts, custom_refresh_indicator, mask_text_input_formatter, shimmer

### libraries/features (Feature Modules)
**Purpose:** Modular, reusable feature packages

**Structure per feature:**
```
{feature_name}/
├── data/
│   ├── datasources/          # API, local storage
│   └── repositories/         # Repository implementations
├── di/
│   └── {feature_name}_module.dart  # Feature-specific DI
├── domain/
│   ├── entities/             # Business objects
│   ├── repositories/         # Repository contracts
│   └── usecases/            # Business logic
└── presentation/
    ├── pages/               # Feature screens
    └── widgets/             # Reusable UI components
```

**Dependencies:** get_it, injectable, equatable, dio, shared_preferences

## App Modules

### modules/app_config
**Purpose:** Application configuration and dependency management

**Features:**
- Version and build information
- Environment-specific settings (.env files)
- Feature flags and toggles
- Global application constants
- Centralized dependency registration
- Hive-based local storage with type adapters

**Environment Files:**
- `.env` - Development
- `.env.uat` - UAT
- `.env.production` - Production

**Dependencies:** hive, get_it, injectable, package_info_plus

### modules/data
**Purpose:** Data layer configuration and implementation

**Features:**
- Remote server configuration (Retrofit)
- Server response handling
- JSON parsing
- Local database (Floor)
- Repository pattern

**Key Files:**
- `injection.dart`: DI initialization
- `data_module.dart`: Server URL configuration
- `response.dart`: JSON parser and response handler
- `/datasource`: API definitions with Retrofit
- `/entities`: Data models with @JsonSerializable()
- `/repositories`: Data storage implementations

**Dependencies:** retrofit, floor, json_serializable, injectable

### modules/theme
**Purpose:** Theming system with Clean Architecture

**Structure:**
- `core/`: Low-level theme configuration and helpers
  - `config/cc_themes.dart`: ThemeData definitions
  - `utils/theme_utils.dart`: ColorScheme builders
- `data/`: Data sources, color tokens
  - `data_source/color/prj_color.dart`: Maps to cc_sdk_ui BaseColors
- `presentation/`: UI-facing styles
  - `style/cc_text_style.dart`: ThemeExtension for TextTheme
  - `provider/`: Theme provider for runtime selection

**Design Principles:**
- Single Source of Truth: cc_sdk_ui exports BaseColors and CcTypographyParams
- Theme-level usage: Use Theme.of(context).textTheme and colorScheme
- Central tokens: Update primitives in cc_sdk_ui

**Dependencies:** cc_sdk_ui

### modules/message
**Purpose:** Internationalization (i18n) and localization

**Features:**
- Multi-language support
- Multi-locale configuration
- Easy string translation
- Pluralization support
- RTL language support
- Fallback locale handling

**Structure:**
```
modules/message/
├── lib/cc_localization.dart    # Main localization service
└── assets/translations/         # Translation files
    ├── en.json                 # English
    └── vi.json                 # Vietnamese
```

**Dependencies:** easy_localization

### modules/widget
**Purpose:** Application-specific widgets (non-reusable)

**Focus:** Custom widgets specific to this application that are not meant for reuse across projects.

## Key Technologies

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation for DI
- **Annotations**: @injectable, @module, @preResolve, @named, @singleton, @lazySingleton

### State Management
- **GetX**: State management, routing, dependency injection
- **Bloc**: State management with streams
- **Provider**: State management (alternative)

### Networking
- **Retrofit**: Type-safe HTTP client with annotations
- **Dio**: HTTP client with interceptors

### Storage
- **Hive**: Fast, lightweight NoSQL database
- **Floor**: SQLite ORM with automatic mapping
- **SharedPreferences**: Simple key-value storage

### Code Generation
- **build_runner**: Code generation runner
- **json_serializable**: JSON serialization/deserialization
- **injectable**: DI code generation

### UI & Utilities
- **flutter_hooks**: Code sharing between widgets, animations
- **flutter_svg**: SVG image support
- **google_fonts**: Custom typography
- **shimmer**: Loading placeholders

## Coding Standards

### Clean Architecture Rules
- **Domain layer** must not depend on Data or Presentation layers
- **Data layer** depends on Domain layer (repository interfaces)
- **Presentation layer** depends on Domain layer (use cases)
- Use dependency injection to invert dependencies

### SOLID Principles
- Each class should have a single responsibility
- Use interfaces/abstract classes for contracts
- Depend on abstractions, not concretions
- Use dependency injection extensively

### Naming Conventions
- Feature names: lowercase with underscores (e.g., `user_profile`)
- Classes: PascalCase (e.g., `UserProfileRepository`)
- Files: snake_case (e.g., `user_profile_repository.dart`)
- Private members: prefix with underscore (e.g., `_privateMethod`)

### Annotations
- Use `@JsonSerializable()` for data models
- Use `@injectable`, `@singleton`, `@lazySingleton` for DI
- Use `@RestApi()` for Retrofit clients
- Use `@HiveType()`, `@HiveField()` for Hive models

## Adding New Code

### Where to Place New Features

**Reusable Features** (to be shared across projects):
- Use `libraries/features/` - Follow the Clean Architecture structure (data/domain/presentation)
- Set up DI in `di/{feature_name}_module.dart`
- Export from `lib/features.dart`

**App-Specific Features** (unique to this project):
- Data operations → `modules/data/` (datasource, entities, repositories)
- UI components (non-reusable) → `modules/widget/`
- UI components (reusable) → `libraries/cc_sdk_ui/`
- Configuration → `modules/app_config/`
- Theming → `modules/theme/`
- Localization → `modules/message/`

### Integration Steps

1. **Create the feature structure** following Clean Architecture layers
2. **Add DI annotations** (@injectable, @module, @singleton, etc.)
3. **Register in appropriate module** (data_module.dart, feature module, etc.)
4. **Run build_runner** to generate DI code: `flutter pub run build_runner build --delete-conflicting-outputs`
5. **Import and use** in presentation layer

### Entry Points

- `main.dart` - Production build
- `main_uat.dart` - UAT environment
- `main_logging.dart` - Debug with logging
- `main_free.dart` - Free tier build

Each entry point initializes:
- Dependency injection
- Hive storage
- Localization
- Theme provider

## Error Handling

### Failure Types (from cc_sdk)
- `NetworkFailure`: Network connectivity issues
- `ServerFailure`: Server-side errors
- `AppConfigFailure`: Configuration errors
  - `MissingConfigFailure`: Missing configuration key
  - `InvalidConfigFailure`: Invalid configuration value
  - `SecurityConfigFailure`: Security-related issues

## Important Notes

- This project uses **modular architecture** - understand the difference between libraries (reusable) and modules (app-specific)
- **cc_sdk** and **cc_sdk_ui** are shared libraries - changes affect all projects using them
- **modules** are app-specific - can be customized without affecting other projects
- **Always follow Clean Architecture** - don't create circular dependencies
- **Use build_runner** after any DI or JSON serialization changes
- **Theme tokens** are the single source of truth - update in cc_sdk_ui, not in individual widgets
