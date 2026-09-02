# AGENTS.md — cc_sdk_ui

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- **Check here first** before writing any new widget elsewhere in the repo — this is the design-system/widget
  catalog (buttons, dialogs, form elements, loaders, layout, text, `CcSpace*` spacers). Extending an existing
  component here beats duplicating similar UI in a feature package.
- All widgets must be stateless or manage state via callbacks/`ValueNotifier` only — no `GetxController`/`Obx`.
  The one allowed exception is the `get` package's context/navigation helpers (`Get.context!`, `Get.dialog`,
  `Get.back()` in `CcDialogHelper`) — that is not state management, don't extend the exception to anything
  reactive.
- All widgets consume theme via `CcContextExtension` (`context.ccColorScheme`, `context.ccTextTheme`) and
  dimensions via `context.resp*` — never a hardcoded color, font, or fixed pixel size.
- No DI file — this is a stateless UI library.
