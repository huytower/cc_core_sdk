# AGENTS.md — cc_mixin

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- Reusable mixins for boilerplate reduction (pagination, back-button handling, scaffold config, infinite
  scroll). Must provide functionality via required methods/getters the consumer implements — never impose
  GetX or Bloc directly.
- Keep mixins generic and project-blind; app-specific behavior belongs in the feature that uses the mixin, not
  in the mixin itself.
- No DI file — this is a mixin library.
- Dependencies: every collaborator comes in through the constructor; `getIt` is used only in this package's
  `lib/core/di/di.dart`. A class needing more than 5 dependencies is split into smaller injected classes;
  mixins carry no external dependencies.
