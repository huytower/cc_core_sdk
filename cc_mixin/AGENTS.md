# AGENTS.md — cc_mixin

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- Reusable behavior mixins with no widget of their own (pagination, back-button handling). Depends only on
  `cc_sdk_data` and Flutter, never on `cc_sdk_ui`: a mixin that builds widgets (scaffold config, pull-to-refresh,
  load-more, navigation bar) belongs in `cc_sdk_ui/lib/src/mixins/`. Presentation hooks (e.g.
  `CcDoubleBackToExitMixin.showBackPressHint`) default to plain Material and are overridden by the app.
- Must provide functionality via required methods/getters the consumer implements — never impose
  GetX or Bloc directly.
- Keep mixins generic and project-blind; app-specific behavior belongs in the feature that uses the mixin, not
  in the mixin itself.
- No DI file — this is a mixin library.
- Dependencies: every collaborator comes in through the constructor; `getIt` is used only in this package's
  `lib/core/di/di.dart`. A class needing more than 5 dependencies is split into smaller injected classes;
  mixins carry no external dependencies.
