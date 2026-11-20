# AGENTS.md — cc_sdk_ui

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- **Check here first** before writing any new widget elsewhere in the repo — this is the design-system/widget
  catalog (buttons, dialogs, form elements, loaders, layout, text, `CcSpace*` spacers). Extending an existing
  component here beats duplicating similar UI in a feature package.
- All widgets must be stateless or manage state via callbacks/`ValueNotifier` only — no `GetxController`/`Obx`.
  The package does not depend on `get` at all: dialogs and keyboard helpers take a `BuildContext` (or use
  `Navigator` / `FocusManager`). Don't add it back.
- All widgets consume theme via `CcContextExtension` (`context.ccColorScheme`, `context.ccTextTheme`) and
  dimensions via `context.resp*` — never a hardcoded color, font, or fixed pixel size.
- No DI file — this is a stateless UI library.
- Dependencies: every collaborator comes in through the constructor; `getIt` is used only in this package's
  `lib/core/di/di.dart`. A class needing more than 5 dependencies is split into smaller injected classes;
  mixins carry no external dependencies.
