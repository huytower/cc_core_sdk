# cc_core_sdk

Universal Logic Layer for Flutter Hybrid-Modular Super Apps - KMP-ready, state-management agnostic core SDK.

## Strategic Guardrails

- **State-Management Agnostic**: Core components MUST NOT depend on Bloc/GetX/Provider for app state
- **Clean Architecture**: Strict Domain/Data/Core layer separation
- **Project-Blind**: Reusable across different enterprise applications
- **Interface-Driven**: All communication via abstractions

## Packages

### cc_sdk
Core utilities, extensions, network, failures, logging.

**Main Components:**
- **Extensions**: Kotlin-style scope/when expressions, UI extensions, logger extension
- **Helpers**: Date/time, device, formatting, images, strings, throttling
- **Network**: CcNetworkInfo, curl utilities
- **Logging**: .Log() extension with environment-based silencing (maps and lists logged as JSON)
- **Crash reporting**: `CcCrashReporter` interface, `CcCrashLogPaths` (the handler lives in `cc_sdk_catcher`)
- **Failures**: CcFailure type hierarchy

### cc_sdk_ui
Design system, responsive widgets, spacing tokens, Plus Jakarta Sans typography.

**Widget Categories:**
- **Buttons**: Base buttons, social login, action buttons
- **Cards**: Base cards, expand/collapse cards
- **Inputs**: Text fields, phone inputs, OTP inputs, country selectors
- **Pages**: Error/loading/empty/retry pages
- **Dialogs**: Base dialogs, modal sheets, message dialogs
- **Navigation**: Curved navigation bar (vendored, MIT), navigation rail
- **Lists**: `CcLoadMoreList` (loads the next page at the list end), pull-to-refresh
- **Extensions**: Context extensions, responsive helpers

**Widget-building mixins** (state-management agnostic): `CcViewConfigMixin`,
`CcPullToRefreshMixin`, `CcLoadMoreMixin`, `CcCurvedNavigationMixin`.

**Design System:**
- **Colors**: CcBaseColors → PrjColors → context.ccColorScheme
- **Typography**: CcTypographyParams → PrjTextStyle → context.ccTextTheme
- **Spacing**: CcSpace* tokens (XS=4, SM=8, MD=12, LG=16, XL=24)
- **Responsive**: context.respPadding(), context.respFontSize(), context.respDim()

### cc_mixin
Reusable behaviors with no widget of their own; depends only on `cc_sdk_data`.

**Mixins:**
- **Pagination**: CcPaginationMixin
- **Back Handling**: CcDoubleBackToExitMixin (override `showBackPressHint` to style the hint)

### cc_sdk_catcher
Capability package: uncaught-error handling on `catcher_2` (`CcCatcherBootstrap`,
`CcCrashReporterHandler`), so the core ring does not depend on it.

### cc_sdk_data
Core data entities and models for shared data structures.

**Components:**
- **Entities**: CcUserEntity, CcDeviceEntity, CcMessageEntity
- **Failures**: CcFailure hierarchy (app config, network, etc.)
- **Services**: CcMessagingService interface

## Usage (Melos Workspace)

Add to your `pubspec.yaml` workspace dependencies:

```yaml
workspace:
  - shared/cc_core_sdk/cc_sdk
  - shared/cc_core_sdk/cc_sdk_ui
  - shared/cc_core_sdk/cc_mixin
  - shared/cc_core_sdk/cc_sdk_data

dependencies:
  cc_sdk:
    path: shared/cc_core_sdk/cc_sdk
  cc_sdk_ui:
    path: shared/cc_core_sdk/cc_sdk_ui
  cc_mixin:
    path: shared/cc_core_sdk/cc_mixin
  cc_sdk_data:
    path: shared/cc_core_sdk/cc_sdk_data
```

## Key Features

### Design System
```dart
// Colors
final color = context.ccColorScheme.primary;

// Typography
final textStyle = context.ccTextTheme.headlineLarge;

// Spacing (use semantic tokens, not raw SizedBox)
CcSpaceSM, CcSpaceMD, CcSpaceLG
```

### Responsive Design
```dart
// Responsive dimensions
final padding = context.respPadding(16);
final fontSize = context.respFontSize(14);
final dimension = context.respDim(100);

// Orientation checks
if (context.isPortrait) { /* portrait layout */ }
if (context.isLandscape) { /* landscape layout */ }
```

### Logging
```dart
// Use .Log() extension (never print() or developer.log())
"Debug message".Log();
"Error occurred".Log(error: exception);
```

### Serialization
The SDK ships no serializer. Apps use `json_serializable` (or `dart:convert`)
on their own models.

## DI Convention

Each package uses the micro-package DI pattern:

```dart
// cc_sdk/lib/core/di/di.dart
@InjectableInit.microPackage()
void initMicroPackage() {
  getIt.init();
}
```

**Important**: When registering core services (e.g., `CcNetworkInfo`), always use `@lazySingleton` to ensure the App Shell's **Turbo Boot** remains under 2 seconds.

## Development

This repository is designed as a git submodule in Flutter projects.

### Workspace Commands
```bash
melos bootstrap              # Link all packages and run pub get
melos run gen                # Generate code for all modules
melos run analyze            # Run analysis for all modules
```

### Submodule Management
```bash
# Pull latest changes from remote
git submodule update --remote --merge

# Fix missing/deleted files
git submodule update --init --recursive --force

# Fix broken boundaries
git rm -r --cached shared/cc_core_sdk
git add shared/cc_core_sdk
```

### Pushing Changes
```bash
# Navigate to submodule
cd shared/cc_core_sdk

# Make changes, commit, push
git add .
git commit -m "Your commit message"
git push origin main

# Update submodule reference in main project
cd ..
git add shared/cc_core_sdk
git commit -m "Update cc_core_sdk submodule"
git push origin main
```

## Quality Standards

- **Suffix-First Naming**: `*_entity.dart`, `*_usecase.dart`, `*_repository.dart`, `*_model.dart`
- **Import Hygiene**: Prefer centralized exports, maintain import order
- **Functional Results**: Use `Result<T, CcFailure>` for error handling
- **No Hardcoded Values**: Use design tokens and localization keys

## Architecture Principles

- **Single Responsibility**: Each package has one clear purpose
- **Open/Closed**: Open for extension, closed for modification
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Performance-Oriented**: Lazy initialization for fast startup
