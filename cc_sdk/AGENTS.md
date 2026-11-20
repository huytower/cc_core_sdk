# AGENTS.md — cc_sdk

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- Universal Logic Layer: network utilities, device info, `CcFailure`, `ccGson` serialization, the `.Log()`
  extension. Must stay state-management agnostic — no Bloc/GetX dependency.
- Every service registered here must be `@lazySingleton` — this package is on the App Shell's critical boot
  path (Turbo Boot < 2s budget).
- `CcBaseColors` (color primitives) lives here; `modules/theme`'s `PrjColors` builds on top of it — don't
  duplicate a primitive that already exists here.
- DI file: `lib/core/di/di.dart`.
- Dependencies: every collaborator comes in through the constructor; `getIt` is used only in this package's
  `lib/core/di/di.dart`. A class needing more than 5 dependencies is split into smaller injected classes;
  mixins carry no external dependencies.
